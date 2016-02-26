<%!from desktop.views import commonheader, commonfooter %>
<%namespace name="shared" file="shared_components.mako"/>
<%namespace name="tree" file="common_tree.mako"/>
<%namespace name="actionbar" file="actionbar.mako"/>

${commonheader("Apachelog", "apachelog", user) | n,unicode}
${shared.menubar(section='mytab')}

## Use double hashes for a mako template comment
## Main body
<div class="container-fluid">
	<div class="row-fluid">
	<div class="span2">
		<div class="sidebar-nav">
		<ul class="sidebar-nav">
			<li class="nav-header"><i class="fa fa-group"></i> 시간
			<div>
				<br/>
                <select id="selectStreamingTime" data-bind="options: selectableStreamingTime, optionsText: 'key', optionsValue: 'value', selectedOptions:chosenStreamingTime, select2: { dropdownAutoWidth: true, update: action, type: 'action', allowClear: true }" style="width: 100%"></select>
			</div>
			</li>
			<li class="nav-header"><i class="fa fa-group"></i> 경고
			<div>
				<br/>
				<select id="selectAlertCount" data-bind="options: selectableAlertCount, optionsText: 'key', optionsValue: 'value', selectedOptions:chosenAlertCount , select2: { dropdownAutoWidth: true, update: action, type: 'action', allowClear: true }" style="width: 100%"></select>
			</div>
		</ul>
		</div>
	</div>
	<div id="page-content-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
					<div id="chart"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="${ static('desktop/ext/js/knockout.min.js') }" type="text/javascript" charset="utf-8"></script>
<script src="${ static('desktop/ext/js/knockout-mapping.min.js') }" type="text/javascript" charset="utf-8"></script>
<script src="${ static('apachelog/js/apachelog.ko.js') }" type="text/javascript" charset="utf-8"></script>

<script src="${ static('desktop/ext/js/moment-with-locales.min.js') }" type="text/javascript" charset="utf-8"></script>
<script src="${ static('desktop/js/jquery.hiveautocomplete.js') }" type="text/javascript" charset="utf-8"></script>
<script src="${ static('desktop/js/jquery.filechooser.js') }" type="text/javascript" charset="utf-8"></script>
<script src="${ static('apachelog/js/highstock.js') }"></script>

<script type="text/javascript" charset="utf-8">
	ko.options.deferUpdates = true;
	var viewModel = new ApachelogViewModel();
	ko.applyBindings(viewModel);

	##$("#selectedStreamingTime").select2("val", "");
	$("#selectStreamingTime").change(function() {
	    changeStreamingTime($("#selectStreamingTime").val());

        var chart = $('#chart').highcharts();
        $.each(chart.series, function(index, value){
            if(value.points.length >= $("#selectStreamingTime").val() / 5){
                for(var i=0;i< value.points.length - ($("#selectStreamingTime").val() / 5); i++){
                    console.log(value.points[i])
                    value.points[i].remove();
                }
            }
        });
	});

	$("#selectAlertCount").change(function() {
	    changeAlertCount($("#selectAlertCount").val());
	});

	Highcharts.setOptions({
		global:{
			useUTC: false
		}
	})
	time = new Date().getTime()
	function refreshChart(){
		var chart = $('#chart').highcharts();
		$.getJSON('/apachelog/view/fetch_timeline?threshold=' + $("#selectAlertCount").val() + '&time=' + time, function (data) {

			$.each(data.data, function(index, value){
				var order = -1;
				$.each(chart.series, function(i, s){
					if(value.name == s.name){
						order = i
					}
				});
				if(order == -1){
					chart.addSeries(value)
				}
				else {
					$.each(value.data, function(i, v){
						var redraw = data.data.length == index + 1 ? true : false
						if(chart.series[order].data.length > $("#selectStreamingTime").val() / 5){
							chart.series[order].addPoint(v, redraw, true)
						}
						else {
							chart.series[order].addPoint(v, redraw, false)
						}
					})
				}
			});

			$.each(data.threshold, function(index, value){
				$(document).trigger("error", new Date(value.x) + "code: " + value.key + "\t count: " +value.y);
##                 $.jHueNotify.notify({level: "ERROR", message: new Date(value.x) + " code: " + value.key + "\t count: " +value.y, sticky: false})
				time = value.x;
			})
		});
	}
	$('#chart').highcharts({
		chart: {
			type: 'spline',
			animation: Highcharts.svg, // don't animate in old IE
			marginRight: 10,
			events: {
				load: function () {
					refreshChart()
					setInterval(function(){
						refreshChart()
					}, 5000);
				}
			}
		},
		title: "ApacheLog Trend Chart",
		xAxis: {
			type: "datetime",
			dateTimeLabelFormats:{
				day: '%b %e',
				week: '%b %e'
			}
		},
		yAxis: {
			title: {
				text: 'Count'
			},
			plotLines: [{
				value: 0,
				width: 1,
				color: '#808080'
			}]
		},
		tooltip: {
			formatter: function () {
				return '<b>' + this.series.name + '</b><br/>' +
						Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/>' +
						Highcharts.numberFormat(this.y, 2);
			}
		},
		credits: {
			enabled: false
		},
		legend: {
			enabled: true
		},
		exporting: {
			enabled: false
		},
		plotOptions:{
			series:{
				marker: {
					enabled: false
				}
			}
		}
	});
</script>


${commonfooter(request, messages) | n,unicode}
