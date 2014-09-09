<!--code almost entirely from http://bl.ocks.org/4063663 Mike Bostock's d3 Brushable Scatterplot -->
<!-- Shiny binding from https://github.com/timelyportfolio/shiny-d3-scatterplot -->
<style>

svg {
  font: 10px sans-serif;
  padding: 10px;
}

.axis,
.frame {
  shape-rendering: crispEdges;
}

.axis line {
  stroke: #ddd;
}

.axis path {
  display: none;
}

.frame {
  fill: none;
  stroke: #aaa;
}

circle {
  fill-opacity: .6;
}

circle.greyed {
  fill: #ccc !important;
}

.extent {
  fill: #000;
  fill-opacity: .125;
  stroke: #fff;
}

</style>

<script src="http://d3js.org/d3.v3.min.js"></script>
<script>
var networkOutputBinding = new Shiny.OutputBinding();
$.extend(networkOutputBinding, {
    find: function(scope) {
      return $(scope).find('.shiny-scatterplot-output');
    },
    renderValue: function(el, data) {
      var logscale = data[1];
      var maxPadding = data[2];
      data = data[0];
      if (data == null) return;
    
//remove old graph    
var svg = d3.select("#scatterplot").select("svg").remove();
$("#scatterplot").empty();

var svgWidth = $(".shiny-scatterplot-output").width();
var rowCount = data.length;
var colCount = Object.keys(data[0]).length;

var padding = maxPadding;
var relativeSize = (svgWidth / colCount) - (padding / colCount);
var width = 100;
var size = relativeSize;
var pointRadius = Math.sqrt(relativeSize / Math.sqrt(rowCount));

if (logscale == false) {
  var x = d3.scale.linear()
      .range([padding / 2, size - padding / 2]);
  
  var y = d3.scale.linear()
      .range([size - padding / 2, padding / 2]);
} else {
  
  var x = d3.scale.log()
    .range([padding / 2, size - padding / 2]);
  
  var y = d3.scale.log()
    .range([size - padding / 2, padding / 2]);
}


var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    .ticks(5);

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(5);

var color = d3.scale.category10();
  
  var domainByTrait = {},
      traits = d3.keys(data[0]),
      n = traits.length;

  traits.forEach(function(trait) {
    domainByTrait[trait] = d3.extent(data, function(d) { return +d[trait]; });
  });
        
//move the append svg down here since depends on n
svg = d3.select("#scatterplot").append("svg")
      .attr("width", size * n + padding)
      .attr("height", size * n + padding)
    .append("g")
      .attr("transform", "translate(" + padding + "," + padding / 2 + ")");
  xAxis.tickSize(size * n);
  yAxis.tickSize(-size * n);

  var brush = d3.svg.brush()
      .x(x)
      .y(y)
      .on("brushstart", brushstart)
      .on("brush", brushmove)
      .on("brushend", brushend);

  svg.selectAll(".x.axis")
      .data(traits)
    .enter().append("g")
      .attr("class", "x axis")
      .attr("transform", function(d, i) { return "translate(" + (n - i - 1) * size + ",0)"; })
      .each(function(d) { x.domain(domainByTrait[d]); d3.select(this).call(xAxis); });

  svg.selectAll(".y.axis")
      .data(traits)
    .enter().append("g")
      .attr("class", "y axis")
      .attr("transform", function(d, i) { return "translate(0," + i * size + ")"; })
      .each(function(d) { y.domain(domainByTrait[d]); d3.select(this).call(yAxis); });

  var cell = svg.selectAll(".cell")
      .data(cross(traits, traits))
    .enter().append("g")
      .attr("class", "cell")
      .attr("transform", function(d) { return "translate(" + (n - d.i - 1) * size + "," + d.j * size + ")"; })
      .each(plot);

  // Titles for the diagonal.
  cell.filter(function(d) { return d.i === d.j; }).append("text")
      .attr("x", padding)
      .attr("y", padding)
      .attr("dy", ".71em")
      .text(function(d) { return d.x; });

  function plot(p) {
    var cell = d3.select(this);

    x.domain(domainByTrait[p.x]);
    y.domain(domainByTrait[p.y]);

    cell.append("rect")
        .attr("class", "frame")
        .attr("x", padding / 2)
        .attr("y", padding / 2)
        .attr("width", size - padding)
        .attr("height", size - padding);

    cell.selectAll("circle")
        .data(data)
      .enter().append("circle")
        .attr("cx", function(d) { return x(d[p.x]); })
        .attr("cy", function(d) { return y(d[p.y]); })
        .attr("r", pointRadius)
        .style("fill", function(d) { return color(p.y+(d[p.y]>0)); });
    cell.call(brush);
    
  }

  var brushCell;

  // Clear the previously-active brush, if any.
  function brushstart(p) {
    if (brushCell !== p) {
      cell.call(brush.clear());
      x.domain(domainByTrait[p.x]);
      y.domain(domainByTrait[p.y]);
      brushCell = p;
    }
  }

  // Highlight the selected circles.
  function brushmove(p) {
    var e = brush.extent();
    svg.selectAll("circle").classed("greyed", function(d) {
      return e[0][0] > d[p.x] || d[p.x] > e[1][0]
          || e[0][1] > d[p.y] || d[p.y] > e[1][1];
    });
  }

  // If the brush is empty, select all circles.
  function brushend() {
    if (brush.empty()){
    svg.selectAll(".greyed").classed("greyed", false);
    } 
     var circleStates = d3.select('svg').select('g.cell').selectAll('circle')[0].map(function(d) {return d.className['baseVal']});
     Shiny.onInputChange("mydata", circleStates);
  }
  

  function cross(a, b) {
    var c = [], n = a.length, m = b.length, i, j;
    for (i = -1; ++i < n;) for (j = -1; ++j < m;) c.push({x: a[i], i: i, y: b[j], j: j});
    return c;
  }
  

  d3.select(self.frameElement).style("height", size * n + padding + 20 + "px");

    }
  });
  Shiny.outputBindings.register(networkOutputBinding, 'timelyportfolio.networkbinding');
  
  </script>
