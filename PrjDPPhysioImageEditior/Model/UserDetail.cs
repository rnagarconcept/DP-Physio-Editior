using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace prjPhysioImageEditor.Model
{
    public class UserDetail
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public int Status { get; set; }
    }
}