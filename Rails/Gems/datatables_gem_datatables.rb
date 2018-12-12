# app/assets/javascripts/datatables.js
var ptBR = {
  'searchPlaceholder': "Buscar",
  "sEmptyTable": "Nenhum registro encontrado",
  "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
  "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
  "sInfoFiltered": "(Filtrados de _MAX_ registros)",
  "sInfoPostFix": "",
  "sInfoThousands": ".",
  "sLengthMenu": "_MENU_ Resultados por página",
  "sLoadingRecords": "Carregando...",
  "sProcessing": "Processando...",
  "sZeroRecords": "Nenhum registro encontrado",
  "sSearch": '',
  "oPaginate": {
      "sNext": "Próxima",
      "sPrevious": "Anterior",
      "sFirst": "Primeira",
      "sLast": "Última"
  },
  "oAria": {
      "sSortAscending": ": Ordenar colunas de forma ascendente",
      "sSortDescending": ": Ordenar colunas de forma descendente"
  }
}

function loadDatatable (order) {
    order = typeof order !== 'undefined' ? order : 'desc';
    $.each($('.js-datatable'), function(key, value){
        if ( ! $.fn.DataTable.isDataTable($(value)) ) {
            $(value).DataTable({"sDom": "<'skn-datatable-with-actions' <'skn-datatable-header clearfix' <'row'<'col-md-1 js-place-of-actions'><'col-md-11'f>>><'row'<'col-md-12't>><'row'<'col-md-6'li ><'col-md-6' p>>>",
                pagingType: "full_numbers",
                responsive: true,
                language: ptBR,
                "aoColumnDefs": [
                    { "bSortable": false, "aTargets": 'js-disable-sort' }
                ],
                order: [2, order]
            });
        }
    });
}

$(function(){
  loadDatatable();
});


# gemfile
gem 'jquery-datatables-rails',  github: "rweng/jquery-datatables-rails", branch: "master"


# app/assets/javascripts/application.js

# //= require jquery
# //= require jquery-ui
# //= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
# //= require rails-ujs
# //= require cocoon
# //= require_tree .



# view index
table.table.table-hover.js-datatable