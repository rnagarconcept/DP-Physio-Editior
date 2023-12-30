using PrjDPPhysioImageEditior.DataAccess;
using prjPhysioImageEditor.Model;
using System;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace prjPhysioImageEditor.Admin
{
    public partial class Index : System.Web.UI.Page
    {
        private readonly int pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["GridPageSize"]);
        protected void Page_Load(object sender, EventArgs e)
        {            
            if(Session["UserDetails"] == null)
            {
                Response.Redirect("Login.aspx", true);
            }
            else
            {
                BindData();
            }           
        }

        protected void dataListItems_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Find the Image control in the DataList's ItemTemplate
                Image imageControl = (Image)e.Item.FindControl("imageControl");
                // Find the h4 and p elements in the DataList's ItemTemplate
                System.Web.UI.HtmlControls.HtmlGenericControl h4Heading = (System.Web.UI.HtmlControls.HtmlGenericControl)e.Item.FindControl("h4Heading");
                System.Web.UI.HtmlControls.HtmlGenericControl pDescription = (System.Web.UI.HtmlControls.HtmlGenericControl)e.Item.FindControl("pDescription");

                // Retrieve the image bytes from the DataList's DataSource
                var bodyPart = (BodyPart)e.Item.DataItem;
                if(bodyPart != null)
                {
                    if (h4Heading != null)
                    {
                        h4Heading.InnerText = bodyPart.ImageName;
                    }
                    if (pDescription != null)
                    {
                        pDescription.InnerText = bodyPart.Description;
                    }
                    byte[] imageBytes = bodyPart.ImageContent;
                    // Set the image bytes to display the image
                    if (imageControl != null && imageBytes != null && imageBytes.Length > 0)
                    {
                        string base64String = Convert.ToBase64String(imageBytes);
                        imageControl.ImageUrl = "data:image/jpeg;base64," + base64String;
                    }
                }               
            }
        }

        private void BindData()
        {           
            var bodyParts = OracleDataAccessRepository.GetInstance.GetBodyParts(1);
            dataListItems.DataSource = bodyParts;            
            dataListItems.DataBind();
        }
    }
}