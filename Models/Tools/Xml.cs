using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace TRC_GS_COMMUNICATION.Models
{
    public class Xml
    {
        public static XmlNodeList getNodeList(XmlNode node, string nodeParentName, string nodeChildrenName)
        {
            return (node[nodeParentName] == null) ? node.SelectNodes("nothing") : node[nodeParentName].GetElementsByTagName(nodeChildrenName);
        }

        public static string getNodeValueText(XmlNode node, string name)
        {
            string str = (node[name] == null) ? "" : node[name].InnerText;

            str = str.Replace("'", "''");

            return str;
        }
    }
}