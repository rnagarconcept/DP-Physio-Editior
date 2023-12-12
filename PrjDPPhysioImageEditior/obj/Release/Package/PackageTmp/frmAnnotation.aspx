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
                        $('#wPaint').wPaint({ image: 'data:image/png;base64,YVZaQ1QxSjNNRXRIWjI5QlFVRkJUbE5WYUVWVlowRkJRVTlKUVVGQlJHWkRRVTFCUVVGRVkwdDJLMWRCUVVGQ1VrWkNUVlpGV0M4dkx6aFljemMwVTI5eGRsSXhUbVJvVVZSRE5YZzVSQ3N5WVhvck5HSnJkMWhZWkVSaE5GbEJjMHh6UVhKaWJIbGFNV2xyTW5Rdk5qTmlXVUZ0Y1ZKclQwTk1Mek55UVVGdWNYWXZOa3d2THpOTGVpc3hObVpYTWs1eE1YaE5NRkIxVFZGVmNEZEdhVkJUY2pZeFlXMVRNRGxyWjIxaFFUVnJTbEpyVG1ndkx6Z3JWbEZNYVVJd2MzRjBNM2RpTTNreFlYbEpZVlpHWVU5VGJuY3JVR3RyVm01S2FGRlRMM2M0Wmt4eGVqWnlaelIxVkhBM1prUmlNa3h4UVd4aFdHczRMMVpXV0RGc1ozYzRkWEpyU0ZOeGRYTllUWE5LUWxka05EbFlkVGhTTVhsa1JuWlZSSGd2ZWs1UVZUZFBPRGgxYzFSU01uVkNVR0pIYlRFMFQxSnRUV2hrTVhSTU1qUjZOM1lyTjNScVlYUTFSMDUxYzA5T2VHSjVUbU5XY1drd1pGZE9iM0pEWVdneU9ESnNTbkU1YmtoMFRtTkhOMDU1Y1hodVRFRndSbVkwUWtWSWVFd3JOazF0VG5oamRuQXhPRVpQY1RkVVpURmplRTFqU1dGeWVUbENibk5pYkhkcFdtOUJVVEpUTW5wMFNVaFRNbTEyZGpoeFkzRmlVR2QzTmtKaFZrVjBabE5FYkZwV01EZERNR0oxYjNrM2RVcDBOblZzYUZkcFJXUXlWMnRyTTNSRmNXRjFPWEZKZW1OdlVYZzNRVUZCVDNkRmJFVlJWbEkwYms4elpEWXdUVk5YVWpoSVkwbGxURFJLUVc5VmJIZFZTbFp2Um5Jd09VVmxWVVpSY2tkNWNERk9UR0Z1YlhrelRtRXpTR0pQZGk5bUx5dGpkVkZDYmxwek5scFBXbVptUjJScVpIWnhPV2xSSzA5NmRucFFiazVvWmtkNGMwcEpVM0ZPU0V3MFdIbEZaRk5yVm5GMVZsVnRXamhvVFdodmRuRlhTVE5zTUdJNWFXWnRVM0l4WldJMlJWQnlkblpwU0VWSWRtSjBabkU1WWpoSWN6azFjVEZtYkRSSFNFOHpNVmR2VGtkNFExRlhjWFpXUTBkeFlXWnFSMkZpWVdaV1IxUmhSRzVyTlc1V05sSTJZbkZoWlRadmQyOWpja3RWTUhWWFFteHNUSEpVU1RWalp6VXdjMnhSUVV0cFEwZ3hOMk5zVTJaa1ozRk1TakZrUkdGeFFYVk1TM2hQZVc4NVlrZGxia1JsTm5wc1dUTkhjMGhHUjFkbk1WWjNRa1pDZEhSemNXZFRZWGwyVkU1TmIwZEtaRkE0VDJKNVNXOVFPRnA2VWxVMVRrUTBUbGhITW5GRlNsUlhWRFJ6TkVWSFNucEJWazFXVFZGU2NWazJiMUUyVkhSa1dVODRNa1paYlVSa2VtTnNRa2RsVWpCNEwyeDNWV2QxY1hCRlMyWnZUbU5oV2xSTFJYZG1NMUV3Wm5wQ2RGcEVXbTE0ZG1wcWQyWTNVbFZoYjJkM1JWUkphMGxUWkVWc1RXcE1WVkZYUm5JMlZYQTJaR3B1YzNoUFNEVjNjMHhIWjJsNVJUUnZVMHhaVTBadmNXNHJLMVpsTjFscVN6QXhUMEpUY1dKaFNWSnBXbE5zYWxGRlNrUnhObmxyVW10MGRXOUxlbVZYWkdodFJXaGpUQ3RRY2pKQlIwUkpiVlZGYVRsMllYTlZWMWRLV1ZWQ1VVdEtNSGhCZHk5b05XWXlSekJEYkd4eFRVaDVRWGQxYlVSSFFuWlJVV2R2V2xaUk1sSnJlSEJNUTFVNVdGcHNaVmxvV1dKNE9EZDRRVmt5TUhKWFZXeFBUVzVUYTJoUlZVOVlVVGcxZVRJNVJWTm9Wa05zYmpWdGIySjZRMVV3U1Rjd05pdE1MMDFaVlhWTVJFUk5iRmx6U0ZCRU4zcE1kM1U0Y3k5d2Ixa3hjV2hpUmxsMVUzZDNZMUZWT1Voc1ZVeHFWRWRUWlhodGFWRXZXVFZVUlV3NWRGbFJkMFpzYzNCWUwwVmlkMUZaVUVwdFNHaHNSRVJvTldsMmEyeDNWazl3VERST1drZFJWWGxxVWxReU1XZ3JZMDF3TTFOUGIwNUZRMUJNWlVscFJWcFhiV2hwWkhjdk1WaHRVVWxOV2twd2JpdHhSVUpOV1VRMGJrazJaakU1Ym5Kck5XZEtSazV4UWxVclFYaEhOV3RrVEVoSk5uUjNTSGR3YjBsdFkyWnVRbE5aYkZwS2FrSTJUbEZMTVhsNFRIazJXV3RNUjNKTEsxbHNhVXMxU2tORWRYTXJNbnBSZUU1cVN6ZEhlSE0xV1dreGEzVktlbU54WWxKM2FGSXJRVkpoWVhsd1ZscE9SRGx1VVc5d1VGWTViVXdyUlVGQ01GVjVOV1pDUW1wWFMxbFhWbEprVWtsU1JtdzFaVUpNT0Vad1RFWXJjSGt5U1ZaeGFXSklXVk5UVkZreVFsbFJNV3BzVjJORmNVcHpNV1Z3VTB4Q1VscEZZazlPUnpoTVp6ZG9lVmR2ZDBWSGQxY3lOVlpxTWsxUldrVkdWREp4VVRacVFYbElZbUZ2Y0RocWRWQnRZazg1VURKaFluUm5OSGswWm10WVRYSkNXSHB2Tnl0a1owbFNTbWhPVUV0V1kxcG1NMHhRTnpoYU1WaERXVzlVVm5sT1ZsVjFXVmRSUzNjeWJrMUpTVzU1VFdoNGMzSjZUa3hrZDFCUmVHcGpWbkJ1VEhWTlRYWTFUbkpyUm5oWlJ6RTFTRll5VDBKemNEQnBiMEZDYVdKNFdUbEVUbWxRY20xWVNtVnZZbGwyZFM5a1IwbGFOVFpvVkVKSE0zSTBSMkZIWlV0clJFc3ZhMkZ0YkRGMGFYWk9LMnRTYkZVeGRFUnZOalJxVTNoc05VcDZXRzlNVldGbWFWSlhjVFZFUldGVFNYaDNRbWR2Y2xCTldFVlhkVzR4WVZkSVZGVkJheXRYYWpCT2QxbFFhbWg1Y2xKS2RUUk5UMmh6Y1d0MVdESlZNVXB3VDA5SVJDdGlOV3BWUm14eVNFNHpjSGhHYzBsV1ZqbHRSVEJyYzNCMVlrVnpNakU0Y2tOS2RscHhiVVZRTWsxbGMwSldhbmRLUm5oT2RYQlJWRk5TV25oVlVscGlWbUYxVW14bWQyNDJVMU4yVVhvcmNHVjRkbk13Y0dSTVZGUklha2RTVkZkNFpVaHdMM2hKYVhWV04zVklhRmhMWWtwU1VGRjZLMncyYURJclNTdElNREJyUjNOeU1EVlZUMlZWYkZseGVsVjJhM2swZVZCNk1rVjBNVmxtYjFrdlZHSjRObXg2ZWpjcmNGSktWREF5YlVzelZYRnJSVGcyY1ZaNWRHNWpNMEo2YVVkamEzZEZiakpOVUd4bFZEZ3llRXByV1dsV1J6VjRiMHRPVUhCNFFteHBNSEZ4U21OSmFETlBVRVI0UlU5dVIySlZhV2hqT0hkM2FFbGlTMjVsZW0xWFpGZExLMkphSzB0cmMxcEpLMDlQYzBKUGNGSndNVFkxZDAxQlRWY3pSbWszVWxSaVZGcFlZbkpMV21aellUazBVMFJUYWtaU2FWUmxRVU5JZUdONGExVTNWR3RFTUhFeVUxWkpjRUp0Y0ZaU1V6VmFUamxFV0VaNFl6bERSVzFGZGpRclp6bHFiRWxHUzAxUGNWaEVZVmx1WTFkWlNWQXZXV2swZFVsYWFVbHZWMG8wTVd0bFNYUnNTVEl6UVZWMUt6bHBabkpDVGxoUE1tMHhPSHBKUlZST1kxSk1TMUpqWjFkQlIwSkdjbkZqTVU1dE4ycHRNREZVUW1sVlVXb3JWMW8yYm5CTldVOU1SaTlUVmtjeFlUZFdWQzk2U1hsRlFXVnFTMGN5YkVWWGVITnJTbUpIWjNaalNFVlpiRUZXV25jNVdWSkZVMnBoVkRGU2EyeE5hVU15U2tSbFNXbDRURWhaYmk5T1VsWjJNSE5TYUVwU1ZVbHFWMHhwWlhwbVYwbGhiMnRqWkZBMmVuZEZaMnhIZDNVMEx5OTNlbU5VYmprM2VXbEJRMnBKZEZsSFkzUk5hSGxNV2xOT2FtZHJRMFJoUWpKT01VdGFjMDl0ZERGM1JXRjFTRFE0ZUVWcU9VWk1NMEpoSzI5NlVqRXZZa0p4UTNoUFNrbERRVmh6V0V0WmRWTXhjMHBDUWtab1puQXhSbWxRYVV0M01YbFJWakpqVDFSMVZVdHZOa3hIZWpBelpGRnhNMVYzTUZKV2VrSnBURFJ6TDJwSlZXbFhaekZYTUc5MFZUUjBlWGc1VTFwcVUyVjRXazFoU1dsdmFHVXpXbmRUVGpkdk1YZzNiekl6TDJrdk5rWlRNR1ppY1c5bE5IVmFXbkJrYkdSUmRXeFhTemd4UmtOMlJWRjJWMjVLVkV4VlUzYzBlbXBhYUcxaVNtNUhZMjVsWnpCMWIyTk9XVmRNTjBOVFNXVk9PVE5GZW1KT2JXUTVUbUZKYmxseVJtWjRkamhDY1dWV1duWklNWEp5ZUhCc2RIQllaemNyZDJsQ1YycHBNM3BRV0dGcE1DdHFZU3NyWm1SQkt5OXVSaXRRVkZvME1rNVJXbmxaTjNOWk1tVTJLM2xPTVRCaGMxaHdlak5PZFhkNVdGRnlVM2hyU0dObGJsRm1jMFpTVW05bVVsTlhkMHBJTkhFdmJVbHlUbXhYY1RFclowOUVjRWs0U0V3M1REUkRkMlo0UjBZNFpUazNiRzFsWVhVNVNXODBkamhvUW5odk5VMXZXRVZUVEdsSmVraDRlamhqZGxreU9XOWFja1pZYm1sUVVtTm1Oa2dyWTJWdk9XaEdOVU5TYVZKME0zaEdRa3dyTm5obFkxSklUblpLZFVaUE9YWkxkblo2ZUVRMVJHaE1PRWN3WkZScFNtMVVUbFZvYVdGU1l5OTJXSFF4Y1RKWVoxVlVTMHhzVlM5MlRWTkNWVlF4ZURncmNsZE1ZUzlTUkZSNE9HbFVTa2g0UVd0VEt6QmhZM2xJYjBwUFEyWlNSVTQyTm1OcVZtZEdLMFJSWms1Tk0waDVUUzl6VjJaRmFWTlllRkkxTlVsRmFsQXliUzk2UzNsRkt6QnFZV3RoUkU1SVluazNhVWwyWnpKV1oxTm5aMHBDWjJ4cFEydzJSMkV4VURjdk5uWTBVa0YwU1hkNFVpczFXR1ZWY2swdmRtNHdURWRxVTNOWkwwVlhibE5vZDB0UVlVNVJUVkptWmtKaFNIQk5TRk5LWTJkalptNTJOVEJ4WlROWFVrMVZiWE5aUW10bWRGTkhlbmsyYmpWRlVYUTBSakk1YzFsTGVETkxVbGxDZDFGMVV6WlRiR3BXVTA1VFZHZHhNV05UZUVWblVrazRiemxLYVhReGFqaG1TVGR5ZERrck9WWXpORmRhY1VkVFpVSnBSbkp4Tmk5WU1VNVlNM2RGUTA5MVdGWTRMeXRUTkVaT1FVcEdNVVpMVW0xYWJYWXhOa1JGZEZoMGVVSmlVWGxDVlZrd1NIQTBNVVV5UjNKSmVWQjRSbGxSVVd0eGFuQnJZMm96Wm5wb1VqQXZORVpTUWpKVlpVaHpWV2xXY1dKVFkyaEphRUpJSzBwTGIzbHphRWhHY0RaYVMybGtkaTluYVhJclFqUjNTVlpGVW5kdmREUkJTVFJ2ZFVWc1ZWUXZabHA0VDBsdVdFMUZTalJaZG5RdlZVVlRaMGx6U1ZSa1dWbDVXblUzTUZGNFpDdENVa3hEUlRNelN5dFBZWFZPTVZGb2VERnVWREJKYXpaa1lTOXhObHBuTTFaUFJUbExTMFZEYjNGWk9WbFRaU3R2VWt4Q2FFTnhTVTl1Vm1SbVNtVTVhVkJLY21aYVZrVlVZV05rYW1RMGVUQnlZbVJ6YVU1UE1VWkpWVms0V21SNGJsRkpVbFpTUkRGSGJFaHZPSFZaY0c5M1dtOUZTVEZTUXpOR1drVjZVVkp6VmtaVlIwcExRMVpHVEZWWFptcHRaRFpKSzBsWk5qZExMMlJuZUZKSEsyeG1ObWt4SzNaUlVYRTVWbnBYV25ab1QySjZSbVYzVldRdlNVWk5lSEJITWpsVGRtdGhZVlJyVlZKc1VrZzVhbFEzUVRJNFFrTm9WVkYwTldKTldrWXhORTVzVWtzeFdDdHNSMGg1Um05YU5uRmhjVTVQVGxaRFNITmpSMFZIZFhsTFZpc3hOeXMwUmtOT1ZrTkxPR05CY1M5MFJXcHRUa1JIYm10a1lsWm5RVTVrVWxCSGNuQTNhVTQwVVc1V1JUZFZXalIwWjFKdWFrRkZiMnhhT0ZGcWFFUlVhbmROVVdWak1HY3JRa1V3WW5WS1oyOTNlak4yYTNGdldWUXpNVUZEYm1kRE5tTkVha0ZIUldwUFduTkpha05zTnk4M1VuZ3JhRXRwYjJsRmFGcFhORkpGTDA5UE9VVTNXVU4xY0RCaFEwOVBWeXM1VlRNMGFIRkxabmhEUlRKV1RUZzVWVEJ2VDNodFJWTlRLelZ1S3psYVZVaEplV3QwVkVkS2NVZE1hMjUzU3poU1drMWhPRFJ6YUVVMWEyYzBjRE5tYjJ4RlZuaFBZMlZKY21kM1dtUTVZVzQ0YmpSRlVURm5Ua3B2VEZGM2FpdDRZV0paZDNkTmVWWlBTMlF6TDJGcFdtNU1aMU5QVmtVeE9XWlJWVzlvY0VjeVoybG5Wbk55YVZGbk5HSklhV1pPTTFBemFscDBORW8wTUVScVdIbzRWRzVwVTBweFVWRTRRWFJ4YVZVdlZUWlRTRGQzUzJkdWRWaE5ORFJzYzJsVldEWXhiMUoyV21Kc1FXVXZabFF3WVZrNU5FbzNNbGM0ZDNCU2JuSXpOMEZEVFhOVmFEVmlTMGhqVm5aTE5YSjFlbk52U0ROUVVsWm1USFpTT0doTmQyZEVLemxzT0dsTlFuRk9lQ3RQVUZBMlJFbERjV052ZWpkMWNFTlNUMDQwY2pFNUt5OWFOWHB2YW5oVlYyeEhhRkJSUWtkclNYSnFNVWhsVTFKRVpqQlNOR2hMYm1GSFEzWkdNbXROTDBjeVpHMW5SMk5sWlZWdlJVUnZXbTU2ZURRclptbFNTUzh3VURVeEwycEpZV2c1TnpVclprOXZPVGhwYVVjMmJFTkdPVWhKVFhoUlVrbDJNM0kwV20wdlNUWlJTQzlJYUNzdmNFaGpZMlJEVFhFM0t5OXZVSGRCVVZkbmVrZ3ZUVXN6T1VjdmJHOUlibXRaZVc5blFqbHdVRU5RY214SUwycHFPUzlZZFZsUmJ5dG1UbnAyWnpkdlNGWllTVmhyWW10bGVEYzVVMUJtVW5rM2FURnVTMU5WYTFVME1HeENaRFU1ZFRadU5sQmpWa3RYZUd4U1RqSnVkamczU0hWS2VFMU1hRTlPZG10S1ZHMVpLM3BIYmpKRllrVlNPWGcyWkRsQ2FHbFlTbmhFZUZCMVNHNUJORlpYY0VsV1RVeFlWVGQ0ZVdkclIxcFBTV2xKZVdsM2JtbzRaM0ZIWkN0b1RtSkJVVlp6ZERsdFFsVmxPRlZKUkd4b1JVcE9MMlp1VEM5RmJWbHBObTFGUkdoR1RrVkhSM05hT1ZSYWFFSlBVWGRpYTNoWmVFOVZXRFJyU21zNVR6azBMMHh3VkhFMGR5c3JNVlEyVG5BNGRqWnRObkZYZW1KU00xWlROV2hCUjBaRVEzbHBNekJWTkVGclMyNWpWemxCWmtJcldFbG1iMXBtVWpkcE1uY3ZkRkpLZVN0SVZFRlJRbWh2WmxSbVVXRTJkRmxxYmsxbmREbEVTRTl6U0hoMFYwbDFlUzlDWTFSWmMySldNME5sVEdGQmFtcEJOazlCVFVJMmJtSkNRazFsV0ZwUWFWTkZkbXBtVnpOdVJESk9lRGRuWlhwVU1IbHBZVnAzV1VKUmFWVnpjRWxZZFhnM1ZXbG1NazlCTTBKSmNVcFpkak5aYWtZNE0yUnVla05JTDJwb1QwWkNTbE5xU2pkNlIweFRVV1J6WWtacE9XbGlhMkZRV21RNE5YRnhRazEyVFV0UFoydEVhbEpKVnpabGEydE5aMDV2VTBKMGJrVnFNbWxtTW5sb2FWaEphRXh0VDFsU1RtWnRjVGhTVjFOa2JERkxUa3BIU2s5UmEyZHZTVEJqVWpSWmJsSTVaRlZ2WjFKcFdFVlljVWxZUlVwclpGQlZORVJVYldoc1pIbEZiWGxuV0hRMVIxQTJSRzlqT1Zjd1VUUnNZVkJ0U1dOUk5YVlhSVGRyTVZacFpqZFZVekJVVkdOQ1FtbFZWVFZaWXpGNlJFRldTa1ZoUzB0NmFsQlNkbGd5UVhwcWFXSjRVWEZ4U1ZrNE5FZ3ZZMEZqYVc4dlpVdDVVSGxxU1doWmMwa3lZMk4zUTJoV1ZWSnlUVmRZVUZWcFYxUklNbmM1YVdkdVNHRjJNV3hXVW5WdGJtWTNaVXA1TlM5bmFVUkhLM2xtY2tkT1lrSkJZMXBTU21aaGJUUnplWHBpTkV4U1VHaDZSa1o0YkRReGJGVlNTbGxTYW5aamRpOVpTWEEwWm5kTFlXRkNibXhvVEZsU2Mwb3hZWGhIVVZOd1REaDRhV0pLUTFwR1VrTllRVmxxZVdkMVRrMXJUREpPZFVKRmQyVklRMXBSVVZKU2NVMUxhVkJHYmtWRlNtdENRVWhoZGxFd2MwMVZPRGRwT0d0aWVXcHNVRXRsU1V4clVGaFZTSFl4T0N0NFEwMVViVXg1VkRSbmVWRjBWVkY1VDJkcFVYSlNWWE5DUzJFeVdrSkhaMmhRZW5OTlNYZzJWVXh0U0cwd05XbFNZMnBLTlZFeE5XdzFUVTlKYWtwTVltNHJOV3RMUWxWT1RHOUpVelZNUldSVlNYZzRXbXR3WjBObmVFeDNjVzlhVVZKcloyY3lORUpOYWt4UWR6QTBVMkZQY1VaRVdUWkRWVzB2ZUZGc1MyaFphVzh4UW5KS1VrRkdlVGRwYmtkdGFFVjRRV2hGZWtsamFsSkxUVWhRZUV0SGJVNDRURk5YYUdOdFRVSk1hazRyV0VvMFdVbE9TWGxqYUdONE9WTnVjVXBtUm5acEsxaDVXVkZDVHpWM1ZXVmpPRUpFTlhsd2FtWlZPVFpTUlhCQ2FFVnJUWFp2VnpGclVuaEpZa3QyZEdWaGFEVjFaR0U0VVdWVUwzQktha2xRTDJadU5FdDJWeXRxTVVOVmRrMWhLMnRJUms1dVNUaFFhekpsUm5Sa09GSlhkbGh1VERSaVRuTTRTekJyVFhwYVdtVlJjRmwyTldseFF6TlZSVkpaYTJaMGNVZHlXV28xTUZGSFlVTmlOVzFJUkhZMWVHNU1WMXBuYW1wWlIwSjVRVlZ4Y21wRmQxUnRNVU51WVd4NFdsaG1aV1F5U214SFozcG9Ra2g0VEhwaFMwa3lkV3RCZWxORmF5OU5UbU4wTkc1MVN6QlBTMDUwY3k5UFFtc3lXbVUxU0VWTWNtd3hPQ3RNY21VemMyb3hjMGcwV2xkUFJIVklLMDlxVFd4c1pIaEllbEpzUkhob2VscEtSVGdyY1VkaVpIZ3JaakJxYmtsaVlUVnZZbmd2TWxCWlNERlpiVVp1VXpGWU9VMHZkRzE2WW5oWllWWjJNVWhpUkVsb1RsaGtNV0kzTHpGd01rb3ZiMW96Tlcxa1VFb3Zka1V4V0cxbFdrOXhjVUZCUVVGQlFWTlZWazlTU3pWRFdVbEpQUT09' });//listData[2]

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
            menuOffsetTop: -10,
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
<body id="bodydia" style="margin: 0px; width: 600px; height: 90%;" role="dialog" onload="resizeWindow()">
    <form id="form1" runat="server" target="_blank" style="height: 750px; width: 750px;">
        <div id="content">
            <%--<center style="margin-bottom: 50px;">
        <input type="button" value="toggle menu" onclick="console.log($('#wPaint').wPaint('menuOrientation')); $('#wPaint').wPaint('menuOrientation', $('#wPaint').wPaint('menuOrientation') === 'vertical' ? 'horizontal' : 'vertical');"/>
      </center>--%>
            <div class="content-box">
                <br />
                <div style="position: relative; margin-left: 30px; text-align: left">
                    <h2 id="patInfo" style="font-family: Arial; font-size: medium; font-weight: 600; color: black"></h2>
                </div>
                <br />
                <div style="position: relative; margin-left: 30px;">
                    <input type="button" id="btnSave" name="btnSave" value="Save Image" style="background-color: forestgreen; color: white; font-weight: 500" onclick='SaveImageShnages()' title="click here to apply the changes made" />
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
