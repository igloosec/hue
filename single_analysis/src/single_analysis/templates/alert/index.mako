<%!from desktop.views import commonheader, commonfooter %>
<%namespace name="shared" file="../shared_components.mako" />

${commonheader("Single Analysis", "single_analysis", user) | n,unicode}
${shared.menubar(section='alert')}

## Use double hashes for a mako template comment
## Main body

<div class="container-fluid">
  <div class="card card-small">
    <h2 class="card-heading simple">Single Analysis app for alert successfully setup!</h2>
    <div class="card-body">
      <p>It's now ${date}.</p>
    </div>
  </div>
</div>
${commonfooter(request, messages) | n,unicode}
