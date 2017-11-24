using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{
    class MajOT
    {
        public DataTable selectListeOt(string where)
        {
            //maj = new MAJ.MAJ();
            return Configs._query.executeProc("TRC_getBLs2", "where@string@" + where);
        }
    }
}
