using Newtonsoft.Json;
using PrjDPPhysioImageEditior.DataAccess;
using prjPhysioImageEditor.DataAccess;
using prjPhysioImageEditor.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace prjPhysioImageEditor.Admin
{
    public partial class Upload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            chkStatus.Checked = true;
        }
        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    var fileInfo = new FileInfo(fileUpload.FileName);
                    var user = Session["UserDetails"] as UserDetail;                   
                    var obj = new BodyPart();
                    obj.Description = txtDescription.Text.Trim();
                    obj.ImageName =  obj.PartName = txtFileName.Text.Trim();                   
                    obj.Status = chkStatus.Checked ? 1 : 0;
                    obj.ImageContent = fileUpload.FileBytes;
                    obj.FormatType = fileInfo.Extension;
                    var success = OracleDataAccessRepository.GetInstance.SaveBodyParts(user.Id, obj);
                    if (success)
                    {
                        Session["BodyParts"] = null;
                        Response.Redirect("index.aspx");
                    }                    
                }
                catch (Exception ex)
                {                 
                }
            }
            else
            {
                // Handle if no file is selected
                // Response.Write("Please select a file to upload.");
            }
        }
    }
}