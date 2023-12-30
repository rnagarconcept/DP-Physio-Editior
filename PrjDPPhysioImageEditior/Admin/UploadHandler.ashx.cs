using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace prjPhysioImageEditor
{
    /// <summary>
    /// Summary description for UploadHandler
    /// </summary>
    public class UploadHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (context.Request.Files.Count > 0)
            {
                HttpPostedFile file = context.Request.Files[0];
                // Process the uploaded file (e.g., save it to the server)
                var path = context.Server.MapPath("~/UploadedImages/");
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                string filePath = context.Server.MapPath("~/UploadedImages/" + file.FileName);
                file.SaveAs(filePath);
                context.Response.ContentType = "text/plain";
                context.Response.Write("~/UploadedImages/" + file.FileName);
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("No file uploaded");
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}