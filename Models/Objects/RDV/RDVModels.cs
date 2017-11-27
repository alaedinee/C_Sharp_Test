using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{
    public class RDVModels
    {
        public string dateRdv { get; set; }
        public string NoBL { get; set; }
        public string actionPlan { get; set; }
        public string client { get; set; }
        public string plan { get; set; }

        public string from { get; set; }
        public string to { get; set; }
        public string rem { get; set; }
        public string type { get; set; }

        public string pause_from { get; set; }
        public string pause_nbrPeriodes { get; set; }
    }
}