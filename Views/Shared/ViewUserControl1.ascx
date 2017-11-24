<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<!doctype html>
<html lang="fr">
<head>
	<meta charset="utf-8">
	<meta name="Author" content="Daniel Hagnoul">
	<title>Forum jQuery</title>
	<style>
		body { background-color:#dcdcdc; color:#000000; font-family:sans-serif; 
		font-size:medium; font-style:normal; font-weight:normal; line-height:normal; 
		letter-spacing:normal; }
		h1,h2,h3,h4,h5 { font-family:serif; }
		div,p,h1,h2,h3,h4,h5,h6,ul,ol,dl,form,table,img { margin:0px; padding:0px; }
		h1 { font-size:2em; text-shadow: 4px 4px 4px #bbbbbb; text-align:center; }
		p { padding:6px; }
		div#conteneur { width:95%; min-width:800px; min-height:500px; margin:12px auto; 
		background-color:#FFFFFF; color:#000000; border:1px solid #666666; }
        
		/* TEST */
		#selectID {
			width: 200px;
		}
	</style>
</head>
<body>
	<h1>Forum jQuery</h1>
	<div id="conteneur">
		
		<select id="selectID" multiple="multiple" size="4">
			<option value="opt 1">Option n° 1</option>
			<option value="opt 2" selected="selected">Option n° 2</option>
			<option value="opt 3">Option n° 3</option>
			<option value="opt 4">0ption n° 4</option>
			<option value="opt 5" selected="selected">Option n° 5</option>
			<option value="opt 6">Option n° 6</option>
		</select>
        
	</div>
	<script charset="utf-8" src="http://code.jquery.com/jquery-1.5.min.js"></script>
 	<script>
 	    /*
 	    * Pour parcourir tous les éléments de la liste
 	    */
 	    var selectList = function (id) {
 	        $("#" + id).children("option").each(function (i, item) {
 	            console.log($(item).val(), $(item).text());
 	        });
 	    };

 	    /*
 	    * Pour parcourir tous les éléments sélectionnés de la liste
 	    */
 	    var selectedList = function (id) {
 	        $("#" + id).children("option:selected").each(function (i, item) {
 	            console.log($(item).val(), $(item).text());
 	        });
 	    };

 	    $(function () {
 	        selectList("selectID");

 	        var obj = $("#selectID");

 	        // déplacer le premier élément en dernière position
 	        obj.children("option:first").appendTo(obj);

 	        // déplacer le premier élément en troisième position
 	        obj.children("option:first").insertAfter(obj.children("option").eq(2));

 	        // copier le cinquième élément en première position
 	        obj.children("option:eq(4)").clone().insertBefore(obj.children("option:first"));

 	        // modifier la valeur de l'élément cloné
 	        obj.children("option:first").val("opt 7");

 	        console.log("------------------");
 	        selectList("selectID");
 	    });
	</script>
</body>
</html>
