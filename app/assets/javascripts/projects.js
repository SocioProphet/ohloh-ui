// handles project edit form
// TODO: Replace all of this with better Javascript. Specifically that cobbled together HTML down there is awful.
ProjectForm = {
  preview_url_name_label: 'label#preview_url_name',
  url_name_input: 'input#project_url_name',
  valid_url_name_re: /^[a-zA-Z][\w-]*$/,

  init: function() {
    $( document ).delegate( 'a.remove_license', 'click', function() {
      $(this).closest('.license').remove();
      $('input.license_id_' + $(this).attr('data_id')).remove();
      if( $('.chosen_licenses').html() === '' ) {
        $('.chosen_licenses').html('<div class="license inset">[None]</div>');
      }
      return false;
    });

    this.license_autocomplete();
  },

  license_autocomplete: function() {
    var licenses = [];
    var add_license = $('#add_license');
    if( add_license.size() === 0 ) return;
    add_license.autocomplete({
      source : '/autocompletes/licenses',
      focus: function(e, ui) {
        $( "add_license" ).val( ui.item.nice_name );
        return false;
      },
      select: function(event, ui) {
        var $input = $("<input />", {
                        type: 'text',
                        style: 'display:none;',
                        name: 'project[project_licenses_attributes][][license_id]',
                        'class': 'license_id_' + ui.item.id,
                        value: ui.item.id });
        $input.insertAfter($('#add_license'));

        licenses.push(ui.item.nice_name)

        if( $.trim($('.chosen_licenses div:first').html()) === '[None]' ) {
          $('.chosen_licenses').html('');
        }

        var html = (''+
        '<div class="license col-md-5 no_margin_left">'+
        '  <div class="col-md-6">#{nice_name}</div>'+
        '  <div class="col-md-5 pull-right" style="margin: 0 20px 20px 0">'+
        '     <a href="#" class="btn btn-danger btn-mini remove_license col" data_id="#{id}">'+
        '        <i class="icon-trash"></i> Remove</a>'+
        '  </div>'+
        '</div>')._f(ui.item);
        $('.chosen_licenses').append(html);
      }
    })
    .autocomplete( "instance" )
    ._renderItem = function( ul, item ) {
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a>" + item.nice_name + "</a>" )
        .appendTo( ul );
    };
  }
}

SimilarProjects = {
  init: function(){
    if($('#projects_show_page').length == 0) return;
    $('#similar_projects').html('');
    $('#related_spinner').show();
    var project_id = $('#similar_projects').attr('project_id');
    $.ajax({
      url: '/p/' + project_id + '/similar_by_tags',
      success: function (data, textStatus) {
        $('#similar_projects').html( data );
      },
      complete: function() {
        $('#related_spinner').hide();
      }
    });
  }
}

SimilarProjects.init();
