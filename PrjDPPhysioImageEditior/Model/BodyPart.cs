using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace prjPhysioImageEditor.Model
{
    public class BodyPart
    {
        public int Id { get; set; }
        public string PartName { get; set; }
        public string Description { get; set; }
        public string ImageName { get; set; }
        public int Status { get; set; }
        public byte[] ImageContent { get; set; }
        public int BodyPartId { get; set; }
        public string FormatType { get; set; }
    }
}