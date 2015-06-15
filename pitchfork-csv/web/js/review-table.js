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
        ],
	"columnDefs": [
	    {
		"targets": [0],
		"visible": false,
		"searchable": false
	    },
	    {
		"targets": [2],
		"data": function ( row, type, val, meta ) {
		    return "<a href=\"http://pitchfork.com/reviews/albums/" + row[0] + "/\">" + row[2] + "</a>";
		}
	    }
	]
    } );      
} );
