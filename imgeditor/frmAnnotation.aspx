<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAnnotation.aspx.cs" Inherits="PrjDPPhysioImageEditior.frmAnnotation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
	<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
    <%-- https://github.com/websanova/wPaint#wpaintjs --%>
    <%-- To start, you will need to include any dependencies (the paths and versions may differ): --%>
    <link rel="Stylesheet" type="text/css" href="./demo/demo.css" />
    <script type="text/javascript" src="./lib/jquery.1.10.2.min.js"></script>
    <!-- jQuery UI -->
    <script type="text/javascript" src="./lib/jquery.ui.core.1.10.3.min.js"></script>
    <script type="text/javascript" src="./lib/jquery.ui.widget.1.10.3.min.js"></script>
    <script type="text/javascript" src="./lib/jquery.ui.mouse.1.10.3.min.js"></script>
    <script type="text/javascript" src="./lib/jquery.ui.draggable.1.10.3.min.js"></script>

    <!-- wColorPicker -->
    <link rel="Stylesheet" type="text/css" href="./lib/wColorPicker.min.css" />
    <script type="text/javascript" src="./lib/wColorPicker.min.js"></script>

    <!-- wPaint -->
    <link rel="Stylesheet" type="text/css" href="./wPaint.min.css" />
    <script type="text/javascript" src="./wPaint.min.js"></script>
    <script type="text/javascript" src="./plugins/main/wPaint.menu.main.min.js"></script>
    <script type="text/javascript" src="./plugins/text/wPaint.menu.text.min.js"></script>
    <script type="text/javascript" src="./plugins/shapes/wPaint.menu.main.shapes.min.js"></script>
    <%--<script type="text/javascript" src="./plugins/file/wPaint.menu.main.file.min.js"></script>--%>
    <script type="text/javascript"> 
    //    window.onload = function() {
    //    var w = window.open("/BodyDiagEditor.aspx","popup", "width=750,height=750,resizable=No,status=yes,toolbar=no,scrollbars=yes,left=0,top=0")
    //     window.opener = "main";
    //     window.open("", "_parent", "");
    //     w.opener.close();
    //}
    </script>
    <script type="text/javascript"> 
        var Patimages;
        var images;
        function loadTemplate() {
            try {
                $.ajax({
                    type: "POST",
                    url: "./frmAnnotation.aspx/getImageTemplate",
                    data: "{}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var bgImage = response.d;
                        $("#wPaint").css("background-image", "url('" + bgImage + "')");
                    }
                });
            }
            catch (err) {
                message.innerHTML = "Input " + err;
            }
        }

        function loadPatientFg() {
            try {
                $.ajax({
                    type: "POST",
                    url: "./frmAnnotation.aspx/getPatientAnnotation",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var listData = data.d; // data.d is a JSON formatted string, to turn it into a JSON object
                        // now that myData is a JSON object we can access its properties like normal
                        //Patimages = listData[2]; 
                        $("#lblUpdateinfo").text(listData[3]);
                        $("#patInfo").text(listData[4]);
                        $('#wPaint').wPaint({ image: listData[2] });

                    }
                });
            }
            catch (err) {
                message.innerHTML = "Input " + err;
            }
        }

        loadTemplate();
        loadPatientFg();
        // init wPaint 
        $('#wPaint').wPaint({
            menuOffsetLeft: 100,
            menuOffsetTop:  -10,
            autoScaleImage: true,               // auto scale images to size of canvas (fg and bg)
            autoCenterImage: true             // auto center images (fg and bg, default is left/top corner)
        });
    </script>
     <script type="text/javascript">  
            // Send the canvas image to the server.  
            function SaveImageShnages() {
                try {
                    var image = $('#wPaint').wPaint('image');
                    //image = image.replace('data:image/png;base64,', '').replace(/^data:image\/(png|jpg);base64,/, "");
                    var data = '{ "imageData" : "' + image + '" }';
                    $.ajax({
                        type: 'POST',
                        url: './frmAnnotation.aspx/SaveImageFgEditor',
                        data: '{ "imageData" : "' + image + '" }',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (msg) {
                            alert('Image changes saved successfully');
                            loadTemplate();
                            loadPatientFg();
                        }
                    });
                }
                catch (err) {
                    message.innerHTML = "Input " + err;
                }
            }
        </script>
</head>
<body id="bodydia">
    <form id="form1" runat="server" target="_blank" style="height: 750px; width: 750px;">
        <div id="content">
            <%--<center style="margin-bottom: 50px;">
        <input type="button" value="toggle menu" onclick="console.log($('#wPaint').wPaint('menuOrientation')); $('#wPaint').wPaint('menuOrientation', $('#wPaint').wPaint('menuOrientation') === 'vertical' ? 'horizontal' : 'vertical');"/>
      </center>--%>
            <div class="content-box">
                <br />
                 <div style="position: relative; margin-left: 30px;text-align:left">
                     <h2 id="patInfo"  style="font-family: Arial; font-size: medium; font-weight: 600; color: black"></h2>
                 </div>
                <br />
                <div style="position: relative; margin-left: 30px;">
                    <input type="button" id="btnSave" name="btnSave" value="Save Image" style="background-color:forestgreen;color:white;font-weight:500" onclick='SaveImageShnages()' title="click here to apply the changes made" />
                    <label id="lblUpdateinfo" style="font-family: Arial; font-size: medium; font-weight: 600; color: dimgray"></label>
                </div>
                <div id="wPaint" style="position: relative; width: 750px; height: 750px; margin-left: 30px; border: ridge; background-image: url('./images/none.png')">
                    <%--      <img src="images/13-07-2019- 114758- AM.png" />--%>
                </div>
                <div id="wPaint-img"></div>
            </div>
        </div> 
       
    </form>
</body>
</html>
