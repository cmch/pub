$(document).ready( function () {
    $('#demo').html( '<table cellpadding="0" cellspacing="0" border="0" class="display" id="example"></table>' );
 
    $('#example').dataTable( {
        "data": albums,
        "columns": [
            { "title": "Link" },
            { "title": "Artist" },
            { "title": "Title" },
            { "title": "Reviewer"},
            { "title": "Date"},
            { "title": "Score"}
        ]
    } );      
} );
