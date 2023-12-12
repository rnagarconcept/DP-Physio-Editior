using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Security.Cryptography;

namespace Public.Library.ErrorHandeling
{
    public class clsEvntvwrLogging
    {
        public static void fnLogWritter(Exception ex)
        {
            StringBuilder strBuilder = new StringBuilder();
            strBuilder.Append("Exception Type " + Environment.NewLine);
            strBuilder.Append(ex.GetType().Name);
            strBuilder.Append(Environment.NewLine + Environment.NewLine);
            strBuilder.Append("Message" + Environment.NewLine);
            strBuilder.Append(ex.Message + Environment.NewLine + Environment.NewLine);
            strBuilder.Append("Stack Trace" + Environment.NewLine);
            strBuilder.Append(ex.StackTrace + Environment.NewLine + Environment.NewLine);

            Exception Innerex = ex.InnerException;
            while (Innerex != null)
            {
                strBuilder.Append("Exception Type " + Environment.NewLine);
                strBuilder.Append(Innerex.GetType().Name);
                strBuilder.Append(Environment.NewLine + Environment.NewLine);
                strBuilder.Append("Message" + Environment.NewLine);
                strBuilder.Append(Innerex.Message + Environment.NewLine + Environment.NewLine);
                strBuilder.Append("Stack Trace" + Environment.NewLine);
                strBuilder.Append(Innerex.StackTrace + Environment.NewLine + Environment.NewLine);

                Innerex = Innerex.InnerException;
            }

            if (!EventLog.SourceExists("ConceptSoft"))
            {
                EventLog.CreateEventSource("ConceptSoft", "ConceptSoft Log");
                EventLog log = new EventLog();
                log.Source = "ConceptSoft";

                log.WriteEntry(strBuilder.ToString(), EventLogEntryType.Error);
            }

            else if (EventLog.SourceExists("ConceptSoft"))
            {
                EventLog log = new EventLog();
                log.Source = "ConceptSoft";

                log.WriteEntry(strBuilder.ToString(), EventLogEntryType.Error);
            }
        }

        public static void fnMsgWritter(string ex)
        {

            if (!EventLog.SourceExists("ConceptSoft"))
            {
                EventLog.CreateEventSource("ConceptSoft", "ConceptSoft Log");
                EventLog log = new EventLog();
                log.Source = "ConceptSoft";

                log.WriteEntry(ex.ToString(), EventLogEntryType.Information);
            }

            else if (EventLog.SourceExists("ConceptSoft"))
            {
                EventLog log = new EventLog();
                log.Source = "ConceptSoft";

                log.WriteEntry(ex.ToString(), EventLogEntryType.Information);
            }

        }

        public static void SaveErrorInLogFile(string strerrormsg)
        {
            try
            {
                string path = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + @"\Logs";
                if (!System.IO.Directory.Exists(path)) System.IO.Directory.CreateDirectory(path);

                string strLogFileName = path + @"\Error-" + DateTime.Now.ToString("dd-MMM-yyyy") + ".txt";
                if (!File.Exists(strLogFileName)) File.Create(strLogFileName);
                File.AppendAllText(strLogFileName, strerrormsg);
                string strBreack = "---------------------------------------------------------" + DateTime.Now.ToString() + "---------------------------------------------------------";
                File.AppendAllText(strLogFileName, strBreack);

            }
            catch (System.IO.IOException ex)
            {
                fnLogWritter(ex);
            }


        }

        public static DateTime ParseDate(string date)
        {
            System.Globalization.DateTimeFormatInfo dateFormatProvider = new System.Globalization.DateTimeFormatInfo();
            dateFormatProvider.ShortDatePattern = "dd/MM/yyyy";
            return DateTime.Parse(date, dateFormatProvider);
        }

        //Show alert in HTML Pages
        public static void ShowHTMLAlert(string message)
        {
            string displayMessage = message.Replace("'", "\'");
            Page page = HttpContext.Current.CurrentHandler as Page;
            string msgscript = "<script type=\"text/javascript\">alert('" + displayMessage + "');</script>";

            if (page != null && !page.ClientScript.IsClientScriptBlockRegistered("alert"))
            {
                page.ClientScript.RegisterClientScriptBlock(page.GetType(), "alert", msgscript);
                return;
            }
        }
    }
    public class clsSecurity
    {
        //string Encrption
        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        //string Decrption
        public static string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            cipherText = cipherText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

    }
    public class clsDatabaseLogging
    {
        public static void SaveErrorInLogFile(string strerrormsg)
        {
            try
            {
                string path = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + @"\Logs";
                if (!System.IO.Directory.Exists(path)) System.IO.Directory.CreateDirectory(path);

                string strLogFileName = path + @"\Error-" + DateTime.Now.ToString("dd-MMM-yyyy") + ".txt";
                if (!File.Exists(strLogFileName)) File.Create(strLogFileName);
                File.AppendAllText(strLogFileName, strerrormsg);
                string strBreack = "---------------------------------------------------------" + DateTime.Now.ToString() + "---------------------------------------------------------";
                File.AppendAllText(strLogFileName, strBreack);

            }
            catch (System.IO.IOException ex)
            {
                clsEvntvwrLogging.fnLogWritter(ex);
            }


        }
    }
}
