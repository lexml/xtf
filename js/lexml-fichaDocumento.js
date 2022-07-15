/* CONTROLE DA TABELA DE LOCALIZACOES DA DOUTRINA */

function montarTabelaDispBibAmplo(idDispBibCompacto){
	var tabela= "<table class=\"tabelaDispBibAmplo\" cellspacing=\"0\">"+
		    "  <thead>"+
		    "    <tr>"+
		    "      <th>Biblioteca</th>"	+
		    "      <th>Localização</th>"+
		    "    </tr>"+
		    " </thead>"+
		    " <tbody>";

	//montando tabela
	$(idDispBibCompacto).find("span[class=controlTitleDivBib]").each(
		function (i, id_i){
			var sLoc= $(id_i).attr("title").split('. Localização\:');
			var sLocDiv= sLoc[1].split("],[");

			sLocDiv[0]= sLocDiv[0].replace(/^.?\[ */,'');
			sLocDiv[sLocDiv.length-1]= sLocDiv[sLocDiv.length-1].replace(/ *\] *$/,'');

			tabela+= "<tr><td class=\"tabelaDispBibAmploCima\" rowspan=\""+sLocDiv.length+"\">"+ $(id_i).text() + " - " + sLoc[0]+"</td>";

			for (var i= 0; i< sLocDiv.length; i++){
				if (i== 0){
					tabela+="<td class=\"tabelaDispBibAmploCima\">"+sLocDiv[0]+"</td></tr>";
				} else {
					tabela+= "<tr><td>"+sLocDiv[i]+"</td></tr>";
				}
			}
		}
	);

	tabela+= " </tbody>"+
		 "</table>";

	//injetando tabela
	$(idDispBibCompacto).next().html(tabela); //dispBibAmplo
	$(idDispBibCompacto).next().slideDown("fast");
}

function openTitleDiv() {
	if ($(this).parent().next().find("table").is("*")){
		$(this).parent().next().slideUp("fast");
		$(this).parent().next().empty();
	} else {
		montarTabelaDispBibAmplo($(this).parent());
	}
}

/* CONTROLE DA TABELA DE REFERENCIAS BIBLIOGRAFICAS DA LEI */

// Define two custom functions (asc and desc) for string sorting
jQuery.fn.dataTableExt.oSort['string-case-asc'] = function(x, y) {
	sX= $(x).text();
	sY= $(y).text();

	if (sX== ""){
		sX= x;
	}
	if (sY== ""){
		sY= y;
	}

	return ((sX < sY) ? -1 : ((sX > sY) ? 1 : 0));
};

jQuery.fn.dataTableExt.oSort['string-case-desc'] = function(x, y) {
	sX= $(x).text();
	sY= $(y).text();

	if (sX== ""){
		sX= x;
	}
	if (sY== ""){
		sY= y;
	}
	return ((sX < sY) ? 1 : ((sX > sY) ? -1 : 0));
};

$(document).ready(function() {

	//controla a localização de bibliotecas em tablets
	$("a[class=controlTitleDivA]").each(function(i,span) {
	        $(span).click(openTitleDiv);
	});

	//controla a tabela de doutrina
	window['old_highlight_text'] = '';
	$('#doutrinaReferenciadaTable').dataTable({
		// "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Todas"]],
		// "sScrollY": "600px",
		"sScrollX": "100%",
		"bAutoWidth": false,
		"aaSorting" : [ [ 0, 'desc' ], [ 1, 'asc' ], [ 2, 'asc'] ],
		"aoColumnDefs" : [ {
			"sType" : 'string-case',
			"aTargets" : [ 2 ]
		} ],
		"bPaginate" : false,
		"sPaginationType" : "full_numbers",
		"oLanguage" : {
			"sUrl": "/busca/js/dataTables/pt_BR.txt"
		} ,
		"fnDrawCallback" : function() {
		        	var text = $('#doutrinaReferenciadaTable_filter input[type="text"]')[0].value;
				var old_text = window['old_highlight_text'];
				if(text != old_text) {
					if(text && (text != '')) {
						if(old_text != '') {
							$('#doutrinaReferenciadaTable').removeHighlight();
						}
						$.each(text.split(" "), function(idx, val) {
							if ($.trim(val)!= ""){
								$('#doutrinaReferenciadaTable').highlight(val);
							}
						});
					} else {
						$('#doutrinaReferenciadaTable').removeHighlight();
				}
				window['old_highlight_text'] = text;
			}
		}
	});
});
