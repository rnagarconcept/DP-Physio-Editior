using log4net;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Common;
using System.Linq;
using System.Web;

namespace PrjDPPhysioImageEditior.DataAccess
{
    public enum DateFormatTypeEnum
    {
        [Description("dd/MMM/yyyy")]
        FIRST,
        [Description("dd-MMM-yyyy")]
        SECOND
    }
    public static class OracleDataReaderEx
    {
        private readonly static ILog log = LogManager.GetLogger(typeof(OracleDataReaderEx));
        public static int ToInt32(this DbDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] is DBNull)
                    return 0;
                var ordinal = reader.GetOrdinal(columnName);
                return Convert.ToInt32(reader[ordinal]);
            }
            catch (Exception ex)
            {
                log.Error($"Error OracleDataReaderEx ToString for {columnName} {ex.Message}", ex);
            }
            return 0;
        }

        public static string ToString(this DbDataReader reader, string columnName)
        {
            try
            {
                if (reader[columnName] is DBNull)
                    return string.Empty;
                var ordinal = reader.GetOrdinal(columnName);
                return Convert.ToString(reader[ordinal]);
            }
            catch (Exception ex)
            {
                log.Error($"Error OracleDataReaderEx ToString for {columnName} {ex.Message}", ex);
            }
            return string.Empty;
        }

        public static string ConvertDateToString(this DbDataReader reader, string columnName, DateFormatTypeEnum dateFormatType)
        {
            if (reader[columnName] is DBNull)
                return string.Empty;
            var ordinal = reader.GetOrdinal(columnName);
            var inputDate = Convert.ToString(reader[ordinal]);
            DateTime date = Convert.ToDateTime(inputDate);
            string formattedDate = inputDate;
            if (dateFormatType == DateFormatTypeEnum.FIRST)
            {
                formattedDate = date.ToString("dd-MMM-yyyy").Replace("-", "/");
            }
            if (dateFormatType == DateFormatTypeEnum.SECOND)
            {
                formattedDate = date.ToString("dd-MMM-yyyy");
            }

            return formattedDate;
        }
        public static bool ToBoolen(this DbDataReader reader, string columnName)
        {
            if (reader[columnName] is DBNull)
                return false;
            var ordinal = reader.GetOrdinal(columnName);
            return reader.GetInt32(ordinal) > 0;
        }

        public static DateTime ToDateTime(this DbDataReader reader, string columnName)
        {
            if (reader[columnName] is DBNull)
                return DateTime.Now;
            var ordinal = reader.GetOrdinal(columnName);
            return reader.GetDateTime(ordinal);
        }

        public static DateTime? ToDateTimeNullable(this DbDataReader reader, string columnName)
        {
            if (reader[columnName] is DBNull)
                return (DateTime?)null;
            var ordinal = reader.GetOrdinal(columnName);
            return reader.GetDateTime(ordinal);
        }
    }
}
