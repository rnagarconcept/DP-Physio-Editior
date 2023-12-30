using PrjDPPhysioImageEditior.DataAccess;
using prjPhysioImageEditor.DataAccess;
using prjPhysioImageEditor.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace prjPhysioImageEditor.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        private List<UserDetail> users;
        protected void Page_Load(object sender, EventArgs e)
        {           
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if(string.IsNullOrEmpty(txtUserName.Text.Trim()) || string.IsNullOrEmpty(txtPassword.Text.Trim()))
            {
                lblMessage.Text = "Please enter valid user name and password";
                lblMessage.Visible = true;
            }
            else
            {
                var found = OracleDataAccessRepository.GetInstance.GetUserDetails(txtUserName.Text.Trim(),txtPassword.Text.Trim());
                if(found != null && found.Status > 0)
                {
                    Session["UserDetails"] = found;
                    Response.Redirect("Index.aspx", true);
                }
                else
                {
                    lblMessage.Text = "Sorry User not exists or disabled";
                    lblMessage.Visible = true;
                }
            }
        }
    }
}