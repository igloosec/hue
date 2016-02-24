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
              <select id="selectStreamingTime" data-bind="options: selectableStreamingTime, selectedOptions:chosenStreamingTime, select2: { dropdownAutoWidth: true, update: action, type: 'action', allowClear: true }" style="width: 100%"></select>
            </div>
          </li>
          <li class="nav-header"><i class="fa fa-group"></i> 경고
            <div>
              <br/>
              <select id="selectAlertCount" data-bind="options: selectableAlertCount, selectedOptions:chosenAlertCount , select2: { dropdownAutoWidth: true, update: action, type: 'action', allowClear: true }" style="width: 100%"></select>
            </div>
        </ul>
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

<script type="text/javascript" charset="utf-8">
  ko.options.deferUpdates = true;
  var viewModel = new ApachelogViewModel();
  ko.applyBindings(viewModel);

  ##$("#selectedStreamingTime").select2("val", "");
  $("#selectStreamingTime").change(function() {
    changeStreamingTime($("#selectStreamingTime").val());
  });

  $("#selectAlertCount").change(function() {
    changeAlertCount($("#selectAlertCount").val());
  });

</script>


${commonfooter(request, messages) | n,unicode}
