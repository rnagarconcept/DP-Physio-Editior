using log4net;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using prjPhysioImageEditor.DataAccess;
using prjPhysioImageEditor.Model;
using System;
using System.Collections.Generic;
using System.Data;

namespace PrjDPPhysioImageEditior.DataAccess
{
    public class OracleDataAccessRepository : RepositoryBase
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(OracleDataAccessRepository));
        private static readonly Lazy<OracleDataAccessRepository> lazy = new Lazy<OracleDataAccessRepository>(() => new OracleDataAccessRepository());
        private OracleDataAccessRepository()
        {
        }

        public static OracleDataAccessRepository GetInstance
        {
            get
            {
                return lazy.Value;
            }
        }
        
        public UserDetail GetUserDetails(string username, string password)
        {
            OracleConnection con = null;
            UserDetail result = null;
            try
            {
                con = OpenConnection();
                OracleCommand OraCmd = new OracleCommand();
                OraCmd.Connection = con;
                OraCmd.CommandType = CommandType.StoredProcedure;
                OraCmd.CommandText = OraCmd.CommandText = $"{PackageName}.GET_USERDETAILS";
                OraCmd.Parameters.Add("P_USERNAME", OracleDbType.NVarchar2,username, ParameterDirection.Input);
                OraCmd.Parameters.Add("P_PASSWORD", OracleDbType.NVarchar2, password, ParameterDirection.Input);
                OraCmd.Parameters.Add(new OracleParameter("p_refcur", OracleDbType.RefCursor, ParameterDirection.Output));
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                OraCmd.ExecuteNonQuery();
                var reader = ((OracleRefCursor)OraCmd.Parameters["p_refcur"].Value).GetDataReader();
                if (reader.HasRows)
                {
                    result = new UserDetail();
                    while (reader.Read())
                    {
                        result.Id = reader.ToInt32("ID");
                        result.UserName = reader.ToString("UserName");
                        result.Status = reader.ToInt32("Status");
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return result;

        }

        public bool SaveBodyParts(int createdBy, BodyPart bodyPart)
        {
            OracleConnection con = null;
            bool result = false;
            try
            {
                con = OpenConnection();
                OracleCommand OraCmd = new OracleCommand();
                OraCmd.Connection = con;
                OraCmd.CommandType = CommandType.StoredProcedure;
                OraCmd.CommandText = OraCmd.CommandText = $"{PackageName}.SAVE_BODY_PARTSDETAILS";
                OraCmd.Parameters.Add("P_BODYPART", bodyPart.PartName);
                OraCmd.Parameters.Add("P_DESCRIPTION", bodyPart.Description);
                OraCmd.Parameters.Add("P_CREATEDBY", createdBy);
                OraCmd.Parameters.Add("P_STATUS", 1);                
                OracleParameter blobParameter = new OracleParameter("P_IMAGEDATA", OracleDbType.Blob);
                blobParameter.Value = bodyPart.ImageContent;
                OraCmd.Parameters.Add(blobParameter);
                OraCmd.Parameters.Add("P_EXT", bodyPart.FormatType);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                OraCmd.ExecuteNonQuery();
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
                throw ex;
            }
            return result;
        }

        public bool SaveBodyParts(int createdBy, int id, string name, byte[] imageContent, string ext)
        {
            OracleConnection con = null;
            bool result = false;
            try
            {
                con = OpenConnection();
                OracleCommand OraCmd = new OracleCommand();
                OraCmd.Connection = con;
                OraCmd.CommandType = CommandType.StoredProcedure;
                OraCmd.CommandText = OraCmd.CommandText = $"{PackageName}.SAVE_BODYIMAGES";
                OraCmd.Parameters.Add("P_CREATEDBY", createdBy);
                OraCmd.Parameters.Add("P_Id", id);
                OraCmd.Parameters.Add("P_NAME", name);                
                OracleParameter blobParameter = new OracleParameter("P_IMAGEDATA", OracleDbType.Blob);
                blobParameter.Value = imageContent;
                OraCmd.Parameters.Add(blobParameter);
                OraCmd.Parameters.Add("P_EXT", ext);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                OraCmd.ExecuteNonQuery();
                result = true;
            }
            catch (Exception ex)
            {
                result = false;
                throw ex;
            }
            return result;
        }

        public List<BodyPart> GetBodyParts(int status)
        {
            OracleConnection con = null;
            List<BodyPart> result = null;
            try
            {
                con = OpenConnection();
                OracleCommand OraCmd = new OracleCommand();
                OraCmd.Connection = con;
                OraCmd.CommandType = CommandType.StoredProcedure;
                OraCmd.CommandText = OraCmd.CommandText = $"{PackageName}.GET_BODYPARTS";
                OraCmd.Parameters.Add("Status", status);               
                OraCmd.Parameters.Add(new OracleParameter("p_refcur", OracleDbType.RefCursor, ParameterDirection.Output));
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                OraCmd.ExecuteNonQuery();
                var reader = ((OracleRefCursor)OraCmd.Parameters["p_refcur"].Value).GetDataReader();
                if (reader.HasRows)
                {
                    result = new List<BodyPart>();                    
                    while (reader.Read())
                    {
                        var obj = new BodyPart();
                        obj.Id = reader.ToInt32("ID");
                        obj.ImageName = reader.ToString("BODYPART");
                        obj.Description = reader.ToString("DESCRIPTION");
                        obj.FormatType = reader.ToString("FORMATTYPE");
                        var contents = reader["IMAGEDATA"];
                        obj.ImageContent = ReadBlob(reader);
                        result.Add(obj);
                    }
                }
            }
            catch (Exception ex)
            {

                throw;
            }
            return result;
        }

        public BodyPart GetBodyPartDetails(int id)
        {
            OracleConnection con = null;
            BodyPart result = null;
            try
            {
                con = OpenConnection();
                OracleCommand OraCmd = new OracleCommand();
                OraCmd.Connection = con;
                OraCmd.CommandType = CommandType.StoredProcedure;
                OraCmd.CommandText = OraCmd.CommandText = $"{PackageName}.GET_BODYPART_DETAILS";
                OraCmd.Parameters.Add("P_ID", id);
                OraCmd.Parameters.Add(new OracleParameter("p_refcur", OracleDbType.RefCursor, ParameterDirection.Output));
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                OraCmd.ExecuteNonQuery();
                var reader = ((OracleRefCursor)OraCmd.Parameters["p_refcur"].Value).GetDataReader();
                if (reader.HasRows)
                {                    
                    while (reader.Read())
                    {
                        result = new BodyPart();
                        result.Id = reader.ToInt32("ID");
                        result.ImageName = reader.ToString("BODYPART");
                        result.Description = reader.ToString("DESCRIPTION");
                        result.FormatType = reader.ToString("FORMATTYPE");
                        var contents = reader["IMAGEDATA"];
                        result.ImageContent = ReadBlob(reader);                        
                    }
                }
            }
            catch (Exception ex)
            {

                throw;
            }
            return result;
        }
        private byte[] ReadBlob(OracleDataReader reader)
        {
            var ordinal = reader.GetOrdinal("IMAGEDATA");
            OracleBlob oracleBlob = reader.GetOracleBlob(ordinal);
            var blobBytes = new byte[oracleBlob.Length];
            oracleBlob.Read(blobBytes, 0, (int)oracleBlob.Length);
            return blobBytes;
        }

    }
}