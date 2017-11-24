using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Linq;

namespace TRC_GS_COMMUNICATION.Models
{
    public class ACL
    {
        Dictionary<string, Role> _roles = new Dictionary<string, Role>();
        Dictionary<string, List<MenuItem>> _menus = new Dictionary<string, List<MenuItem>>();

        public void addRole(string name, string parent = "")
        {
            if (!_roles.ContainsKey(name))
            {
                Role role = new Role(name, parent);
                _roles.Add(name, role);
            }
        }

        public void allow(string name, string ressource)
        {
            if (_roles.ContainsKey(name))
            {
                _roles[name].addRessource(ressource.ToLower());
            }
        }

        public bool isAllowed(string name, string ressource)
        {
            bool res = false;

            if (_roles.ContainsKey(name))
            {
                Role role = _roles[name];
                res = role.isAllowed(ressource);
                if (res == false && role.getParentName() != "")
                {
                    res = isAllowed(role.getParentName(), ressource);
                }
            }

            return res;
        }


        public void initRole()
        {
            StringBuilder sp = new StringBuilder();
            sp.Append(File.ReadAllText(Globale_Varriables.VAR.ConfigPath + @"\Roles.xml"));
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(sp.ToString());

            XmlNodeList lstAdr = Xml.getNodeList(doc, "Roles", "Item");
            foreach (XmlNode adr in lstAdr)
            {
                string name = Xml.getNodeValueText(adr, "Name");

                XmlNodeList extends = Xml.getNodeList(adr, "Extends", "Extend");
                if (extends != null && extends.Count > 0)
                {
                    foreach (XmlNode extend in extends)
                    {
                        string val = extend.InnerText;
                        this.addRole(name, val);
                    }

                }
                else
                    this.addRole(name);
            }
        }

        public void initLinks()
        {
            StringBuilder sp = new StringBuilder();
            sp.Append(File.ReadAllText(Globale_Varriables.VAR.ConfigPath + @"\Access.xml"));
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(sp.ToString());

            XmlNodeList lstAdr = Xml.getNodeList(doc, "Access", "Item");
            foreach (XmlNode adr in lstAdr)
            {
                string name = Xml.getNodeValueText(adr, "Role");

                XmlNodeList links = Xml.getNodeList(adr, "Links", "Link");
                if (links != null)
                {
                    foreach (XmlNode link in links)
                    {
                        string val = link.InnerText;
                        this.allow(name, val);
                    }
                }
            }
        }

        private void initMenues()
        {
            XDocument doc =  XDocument.Load(Globale_Varriables.VAR.ConfigPath + @"\Menus.xml");
            doc.Descendants("Menus").Elements("Menu").ToList().ForEach(
                    m => 
                    {
                        string rol = m.Attribute("role").Value;
                        List<MenuItem> MenuItems = new List<MenuItem>();
                        m.Elements("item").ToList().ForEach(
                            i => {
                                MenuItem mi = new MenuItem() { link = i.Element("link").Value, value = i.Element("value").Value };
                                if (i.Element("sitem") != null)
                                {
                                    i.Element("sitem").Elements("item").ToList().ForEach(
                                                                si => mi.Items.Add(new MenuItem() { link = si.Element("link").Value, value = si.Element("value").Value })
                                                                ); 
                                }
                                MenuItems.Add(mi);
                            });
                        this._menus.Add(rol, MenuItems);
                    });
        }

        public string init()
        {
            initRole();
            initLinks();
            initMenues();

            return "Ok";
        }
        public List<MenuItem> getMenu(string role)
        {
            if (_menus.Keys.Contains(role))
                return _menus[role];
            return null;
        }

    }

    public class Role
    {
        private string parent;
        private string name;

        private ArrayList Ressources;

        public Role(string name, string parent = "")
        {
            this.name = name;
            this.parent = parent;
            Ressources = new ArrayList();
        }

        public string getRoleName() { return name; }

        public string getParentName() { return parent; }

        public void addRessource(string ressource)
        {
            if (!Ressources.Contains(ressource))
                Ressources.Add(ressource);
        }

        public bool isAllowed(string ressource)
        {
            return Ressources.Contains(ressource);
        }
    }
    public class MenuItem
    {
        public List<MenuItem> Items {get;set;}
        public string link { get; set; }
        public string value { get; set; }

        public MenuItem()
        {
            Items = new List<MenuItem>();
        }
    }

}