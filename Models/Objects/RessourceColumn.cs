using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TRC_GS_COMMUNICATION.Models
{
    public class RessourceColumn
    {
        public string ID { get; set; }
        public string Type { get; set; }
        public string Input { get; set; }
        public string Code { get; set; }
        public string Label { get; set; }
        public string Value { get; set; }
        public string auto { get; set; }
        public string Required { get; set; }
        public string Editable { get; set; }
        public string Searchable { get; set; }
        public string Source { get; set; }
        public string RegEx { get; set; }
    }
}