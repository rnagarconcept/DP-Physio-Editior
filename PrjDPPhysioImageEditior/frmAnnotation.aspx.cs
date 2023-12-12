using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using PrjDPPhysioImageEditior.webRefConceptWebDataAccess;
using Public.Library.ErrorHandeling;
using System.Data;

namespace PrjDPPhysioImageEditior
{
    public partial class frmAnnotation : System.Web.UI.Page
    {
        public static string strHostingURL = System.Configuration.ConfigurationManager.AppSettings["conceptDataURL"];
        public static string strNetworkUid = System.Configuration.ConfigurationManager.AppSettings["NetwrokUserId"];
        public static string strNetworkPwd = System.Configuration.ConfigurationManager.AppSettings["NetwrokPwd"];
        public static ConceptWebDataAccess objcdws = new ConceptWebDataAccess(strHostingURL);
        public static string strTrnSeq ;
        public static string strtempId ;
        public static string strUid;

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["sq"]) && !string.IsNullOrEmpty(Request.QueryString["tmp"]) && !string.IsNullOrEmpty(Request.QueryString["uid"]))
                {
                    strTrnSeq = Request.QueryString["sq"].Replace(' ', '+');
                    strtempId = Request.QueryString["tmp"].Replace(' ', '+');
                    strUid = Request.QueryString["uid"].Replace(' ', '+');
                }
                if(!string.IsNullOrEmpty(strHostingURL) || !string.IsNullOrEmpty(strNetworkUid) || !string.IsNullOrEmpty(strNetworkPwd))
                {
                    clsEvntvwrLogging.fnMsgWritter("Missing EndPoint credentials, please check web.config");
                }
            }
        }

        private static DataTable ReadXML(string strRead)
        {
            DataTable dtOut = new DataTable();
            try
            {
                StringReader str = new StringReader(strRead);
                DataSet DS = new DataSet();
                DS.ReadXml(str);
                while (DS != null && DS.Tables.Count > 0)
                {
                    dtOut = DS.Tables[0];

                    DS.Dispose();
                    DS = null;
                }
                str.Dispose();
                str.Close();
            }
            catch (Exception ex)
            {
                clsEvntvwrLogging.fnLogWritter(ex);
            }
            return dtOut;
        }

        //return XML document with List of all the new requests
        [WebMethod]
        public static void SaveImageFgEditor(string imageData)
        { 
            try
            {
                if (!string.IsNullOrEmpty(strTrnSeq) && !string.IsNullOrEmpty(strtempId) && !string.IsNullOrEmpty(imageData) && !string.IsNullOrEmpty(strUid))
                {
                    objcdws.Credentials = new System.Net.NetworkCredential(strNetworkUid, strNetworkPwd);
                    objcdws.PreAuthenticate = true;
                    objcdws.UpdatePatAnnonationData(strTrnSeq, strtempId, imageData, strUid); //strtempId
                }
                else clsEvntvwrLogging.ShowHTMLAlert("Error while loading template,Invalid template id");

            }
            catch (Exception ex)
            {
                clsEvntvwrLogging.ShowHTMLAlert("Error :" + ex.Message);
            } 
        }
         
        //return XML document with List of all the new requests
        [WebMethod]
        public static List<string> getPatientAnnotation()
        {
           List<string> lstAnnotations = new List<string>();
            try
            {
                if (!string.IsNullOrEmpty(strTrnSeq) && !string.IsNullOrEmpty(strtempId))
                {
                    objcdws.Credentials = new System.Net.NetworkCredential(strNetworkUid, strNetworkPwd);
                    objcdws.PreAuthenticate = true;
                    string xmlOp = objcdws.GetPatAnnonationDetails(strTrnSeq, strtempId);//strtempId
                    DataTable dtOp = ReadXML(xmlOp);
                    foreach(DataRow drAnt in dtOp.Rows)
                    { 
                        lstAnnotations.Add(drAnt["TNO"].ToString());
                        lstAnnotations.Add(drAnt["A_ID"].ToString());
                        lstAnnotations.Add(drAnt["IMAGE_DATA"].ToString());
                        lstAnnotations.Add(drAnt["UPDATE_INFO"].ToString());
                        lstAnnotations.Add(drAnt["PAT_INFO"].ToString());
                    }

                    dtOp.Dispose();
                    dtOp = null;

                }
                else clsEvntvwrLogging.ShowHTMLAlert("Error while loading template,Invalid template id");

            }
            catch (Exception ex)
            {
                clsEvntvwrLogging.ShowHTMLAlert("Error :" + ex.Message);
            }
            return lstAnnotations;
        }


        //return XML document with List of all the new requests
        [WebMethod]
        public static string getImageTemplate()
        {
            string strBase64 = null;
            try
            {
                if(!string.IsNullOrEmpty(strtempId))
                {
                    objcdws.Credentials = new System.Net.NetworkCredential(strNetworkUid, strNetworkPwd);
                    objcdws.PreAuthenticate = true;
                    strBase64 = objcdws.GetAnnotationTempletBase64(strtempId);
                }
                else clsEvntvwrLogging.ShowHTMLAlert("Error while loading template,Invalid template id");

            }
            catch(Exception ex)
            {
                clsEvntvwrLogging.ShowHTMLAlert("Error :" + ex.Message);
            } 
            return strBase64;
        }
    }
}