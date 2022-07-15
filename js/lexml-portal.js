
// Plugin de abas
$.fn.abas = function() {

  var links = this.find("a");
  var divs = [];

  links
        .each(function(index) {
            this.href = "javascript:void(0)";
            this.idAba = "#" + this.id.substring("aba_".length);
            var div = divs[index] = $(this.idAba);
            if(index == 0) {
                $(this).addClass("selected");
                div.show();
            }
            else {
                div.hide();
            }
        })

        .click(function() {
			$.each(divs, function(index, div) {div.hide()});
			links.removeClass("selected");
			$(this).addClass("selected");
			$(this.idAba).show();
            return false;
        })

        .focus(function() { this.blur() });

  return this;

}

function resumeAssunto(assunto) {
    for(var i = 80; i >= 0; i--) {
    	if(" ,[]{}".indexOf(assunto.charAt(i)) != -1) {
    		break;
    	}
    }
    trecho = assunto.substring(0, i);
    // Quebrou tag?
    if(/<[^>]*$/.test(trecho)) {
            trecho = assunto.substring(0, assunto.indexOf('>', trecho.length) + 1);
    }
    // Fechou "hit"?
    if(/<span[^>]*>[^>]*$/i.test(trecho)) {
            trecho = assunto.substring(0, assunto.indexOf('>', trecho.length) + 1);
    }
    return trecho.length == assunto.length? null: trecho;
}

function preparaAssunto(idx, td) {
	var assunto = $(td).html();
        var trecho = resumeAssunto(assunto);
	if(trecho == null) return;
	var idAf = "_af" + idx;
	var idAa = "_aa" + idx;
	$(td).html('<div id="' + idAf + '">' + trecho + 
		'... <a href="javascript:void(0);" onClick="$(\'#' + idAa + '\').show(); $(\'#' + idAf + '\').hide()">mais</a></div>' +
		'<div id="' + idAa + '" style="display: none">' + assunto + 
		' <a href="javascript:void(0);" onClick="$(\'#' + idAf + '\').show(); $(\'#' + idAa + '\').hide()">menos [x]</a></div>');
}

function preencheuAno(ctl, label) {
	if(!/^\d{4}$/.test(ctl.value)) {
		alert(label + ": informe um ano com 4 números");
		ctl.focus();
		return false;
	}
	return true;
}

function setParam(str, key, value) {
	var regex = new RegExp(key + "=[^;]*");
	if(regex.test(str)) {
		return str.replace(regex, key + "=" + value);
	}
	else {
		if(str.length > 1) str += ";";
		return str + key + "=" + value;
	}
}

function getParam(key) {
	var regex = new RegExp(key + "=([^;&]*)");
	var m = regex.exec(location.search);
	return m? m[1]: "";
}

function initFormIntervalo() {
	var form = $("#data_intervalo form").get(0);
	$(form).submit(function() {
		var de = form["year"];
		var ate = form["year-max"];
		if(!preencheuAno(de, "Ano inicial")) return false;
		if(!preencheuAno(ate, "Ano final")) return false;
		if(parseInt(de.value, 10) > parseInt(ate.value, 10)) {
			alert("O ano inicial deve ser anterior ou igual ao ano final.");
			de.focus();
			return false;
		}
		var s = location.search;
		if(!s) {
			s = "?";
		}
		else {
			s = s.replace(/browse-all=yes/, "").replace(/expandGroup=date-[^;]*;?/, "");
		}
		s = setParam(s, "year", de.value)
		s = setParam(s, "year-max", ate.value);
		location.search = s;				
		return false;
	});	

	var year = form["year"].value = getParam("year");
	var yearMax = form["year-max"].value = getParam("year-max");
	if(location.search.indexOf("expandGroup=date-") == -1 && location.search.indexOf("f1-date=") == -1 && (year.length > 0 || yearMax.length > 0)) {
		$("#selDecadas a:index(1)").click();
	}
}

$(function() {
	$("#selDecadas").abas();
	initFormIntervalo();
	$("div.docHit td.col2:contains(Assuntos) + td.col3").each(preparaAssunto);
});

/*
 * Funções de Expandable - Menos/Mais
 *
 */

var expandableNumMaxLinhas= 20;

//(private)
function abrirFechar(){
	if ($(this).text() == 'mais') {
		$(this).prev().find("tr:gt("+expandableNumMaxLinhas+")").show();
		$(this).text("menos");
	} else {
		$(this).prev().find("tr:gt("+expandableNumMaxLinhas+")").hide();
		$(this).text("mais");
	}
	return false;
}

//(private)
function expandableInjetarControles(key, id) {
	if ($(id).find("tr").length> expandableNumMaxLinhas){
		$(id).find("tr:gt(20)").hide();
		$('<a href="javascript:void(0)" class="expandable-control">mais</a>').insertAfter($(id)).click(abrirFechar);		
	}
}

//Injeta o HTML na class de CSS indicada (public)
function incluirExpandable(className) {
	$(className).each(expandableInjetarControles);
}
