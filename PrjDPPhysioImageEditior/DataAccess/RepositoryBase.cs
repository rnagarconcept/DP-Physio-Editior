using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using prjPhysioImageEditor.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

namespace prjPhysioImageEditor.DataAccess
{
    public class RepositoryBase
    {
        public string ConnectionString { get; set; } = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ToString();
        public string PackageName { get; private set; } = ConfigurationManager.AppSettings["PackageName"].ToString();

        private static OracleConnection con;
        public OracleConnection OpenConnection()
        {
            con = new OracleConnection(ConnectionString);
            con.Open();
            return con;
        }

        public OracleCommand CreateCommand(string commandText, CommandType commandType = CommandType.StoredProcedure)
        {
            var cmd = new OracleCommand(commandText, con);
            cmd.CommandType = commandType;
            return cmd;
        }

        public void CloseConnection()
        {
            //LoggingService.Info($"Connection State {con.State}");
            try
            {
                if (con != null && con.State == System.Data.ConnectionState.Open)
                {
                    con.Close();
                }
            }
            catch (Exception ex)
            {
                //LoggingService.Error($"Error In Connection Close", ex.Message, ex);
            }
        }

        public string DbSchema
        {
            get
            {
                return ConfigurationManager.AppSettings["DB_SCHEMA"];
            }
        }

        public string FileBasePath
        {
            get
            {
                return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Data");
            }
        }
    }
    public class Repository : RepositoryBase
    {
        public Repository()
        {

        }

        public List<UserDetail> GetAllUsers()
        {
            var filePath = Path.Combine(FileBasePath, "userdetail.json");
            var jsonContent = File.ReadAllText(filePath);
            var result = JsonConvert.DeserializeObject<List<UserDetail>>(jsonContent);
            return result;
        }
        public List<BodyPart> GetBodyParts()
        {
            var filePath = Path.Combine(FileBasePath, "bodypart.json");
            var jsonContent = File.ReadAllText(filePath);
            var result = JsonConvert.DeserializeObject<List<BodyPart>>(jsonContent);
            return result;
        }

        public List<BodyPart> SaveBodyPart(BodyPart obj)
        {
            var bodyParts = GetBodyParts();
            var maxId = bodyParts.Max(x => x.Id);
            obj.Id = maxId + 1;
            bodyParts.Add(obj);
            var jsonContent = JsonConvert.SerializeObject(bodyParts);
            var filePath = Path.Combine(FileBasePath, "bodypart.json");
            File.WriteAllText(filePath, jsonContent);
            return bodyParts;
        }
        public bool IsExists(BodyPart obj)
        {
            var bodyParts = GetBodyParts();
            var found = bodyParts.FirstOrDefault(x => x.PartName.Equals(obj.PartName, StringComparison.InvariantCultureIgnoreCase));
            return found != null;
        }
    }
}