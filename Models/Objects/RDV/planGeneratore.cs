using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Omniyat.Models;
using iTextSharp.text.pdf;
using System.IO;
using System.Text;
using iTextSharp.text;
using System.Diagnostics;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{

    public class planGeneratore : System.Web.UI.Page
    {
        //MAJ.MAJ maj = new MAJ.MAJ();
        public DataTable dtPrestationPlan;

        public string PlanID;

        public DataTable getInfoPlanGenerale(string idPlan)
        {
            return Configs._query.executeProc("TRC_GETPLAN_BILAN", "PLANID@int@" + idPlan);
        }




        public DataTable getDtPlanPeriode(string idPlan)
        {
            return Configs._query.executeProc("TRC_getPlanPeriodes", "PlanId@int@" + idPlan);
        }



        public DataTable getDtPlanPrestation(string idPlan)
        {
            return Configs._query.executeProc("TRC_Get_Prestation_Plan", "planID@int@" + idPlan);
        }

        public static byte[] WriteToPdf(FileInfo sourceFile, string stringToWriteToPdf)
        {
            PdfReader reader = new PdfReader(sourceFile.FullName);

            using (MemoryStream memoryStream = new MemoryStream())
            {
                //
                // PDFStamper is the class we use from iTextSharp to alter an existing PDF.
                //
                PdfStamper pdfStamper = new PdfStamper(reader, memoryStream);

                for (int i = 1; i <= reader.NumberOfPages; i++) // Must start at 1 because 0 is not an actual page.
                {
                    iTextSharp.text.Rectangle pageSize = reader.GetPageSizeWithRotation(i);

                    PdfContentByte pdfPageContents = pdfStamper.GetOverContent(i);
                    pdfPageContents.BeginText(); // Start working with text.

                    BaseFont baseFont = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, Encoding.ASCII.EncodingName, false);
                    //pdfPageContents.SetFontAndSize(baseFont, 15);
                    //pdfPageContents.SetRGBColorFill(255, 0, 0); 
                    int dpi = 100;
                    Barcode39 br = new Barcode39();
                    br.Code = stringToWriteToPdf;

                    iTextSharp.text.Image barcodeImage = iTextSharp.text.Image.GetInstance(br.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White), BaseColor.BLACK);

                    barcodeImage.SetAbsolutePosition((pageSize.Width / 2) + (barcodeImage.Width / 2), pageSize.Height - 20);// pageSize.Height - 150

                    barcodeImage.ScalePercent(72f / (float)dpi * 100f);

                    //float textAngle =
                    //    (float)FooTheoryMath.GetHypotenuseAngleInDegreesFrom(pageSize.Height, pageSize.Width);


                    //pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, stringToWriteToPdf,
                    //                                pageSize.Width/2,
                    //                                pageSize.Height/2,
                    //                                textAngle);

                    pdfPageContents.AddImage(barcodeImage, true);
                    //pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, stringToWriteToPdf, (pageSize.Width / 5) *4, pageSize.Height - 150, 0);
                    pdfPageContents.EndText();
                }

                pdfStamper.FormFlattening = true;
                pdfStamper.Close();

                return memoryStream.ToArray();
            }
        }


        public string getFileToPrint(HashSet<string> otid, string newPath)
        {
            //string[] directory = Directory.GetDirectories(Globale_Varriables.VAR.pathFileUpload + @"\File\");

            string _fullpath = Globale_Varriables.VAR.urlFileUpload + @"\File\";

            for (int i = 0; i < otid.Count; i++)
            {
                Document doc = new Document();
                string _otid = otid.ElementAt(i);

                string _file = newPath.Replace("{0}", _otid);
                List<byte[]> _filesByte = new List<byte[]>();
                bool _print = false;
                try
                {
                    PdfCopy writer = new PdfCopy(doc, new FileStream(_file, FileMode.Create));
                    /*
                    PdfWriter pdfW = PdfWriter.GetInstance(doc, new FileStream(_file, FileMode.Create));
                    
                    doc.Close();
                    */

                    doc.Open();

                    //for (int j = 0; j < directory.Length; j++)
                    //{
                    //if (Globale_Varriables.VAR.pathFileUpload + @"\File\" + otid.ElementAt(i) == directory[j])
                    //{
                    string path = _fullpath + _otid; //directory[j];
                    IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
                    foreach (string dir in dirList)
                    {
                        string dpath = dir;
                        string[] type = dpath.Split('\\');
                        IEnumerable<string> fileList = System.IO.Directory.EnumerateFiles(dpath);

                        DataTable dt = Configs._query.executeProc("dev_getList", "parent@string@DocType#name@string@" + type[type.Length - 1]);
                        int nbr = 0;
                        if (Tools.verifyDataTable(dt)) nbr = Int32.Parse(dt.Rows[0]["filter"].ToString());

                        for (int cp = 1; cp <= nbr; cp++)
                        {
                            string[] files = Directory.GetFiles(dpath, "*.pdf");
                            foreach (string file in files)
                            {
                                // file , otid.ElementAt(i)
                                PdfReader reader = new PdfReader(file);
                                reader.ConsolidateNamedDestinations();
                                for (int ic = 1; ic <= reader.NumberOfPages; ic++)
                                {
                                    PdfImportedPage page = writer.GetImportedPage(reader, ic);
                                    writer.AddPage(page);
                                }

                                PRAcroForm form = reader.AcroForm;
                                if (form != null) writer.CopyAcroForm(reader);

                                reader.Close();

                                /*
                                byte[] bt = WriteToPdf(new FileInfo(file), otid.ElementAt(i));
                                _filesByte.Add(bt);
                                 * */
                                _print = true;
                            }
                        }
                    }


                    string[] _files = Directory.GetFiles(path, "*.pdf"); //directory[j], "*.pdf");
                    foreach (string file in _files)
                    {
                        PdfReader reader = new PdfReader(file);
                        reader.ConsolidateNamedDestinations();
                        for (int ic = 1; ic <= reader.NumberOfPages; ic++)
                        {
                            PdfImportedPage page = writer.GetImportedPage(reader, ic);
                            writer.AddPage(page);
                        }

                        PRAcroForm form = reader.AcroForm;
                        if (form != null) writer.CopyAcroForm(reader);

                        reader.Close();
                        /*
                        //file , otid.ElementAt(i)
                        byte[] bt = WriteToPdf(new FileInfo(file), otid.ElementAt(i));

                        _filesByte.Add(bt);
                         * */
                        _print = true;
                    }

                    //}
                    //}

                    writer.Close();
                    doc.Close();

                    if (_print) // _filesByte.Count > 0)
                    {
                        /*
                        _filesByte.Insert(0, File.ReadAllBytes(_file));
                        File.WriteAllBytes(_file, PDF.PdfMerger.MergeFiles(_filesByte));
                        */

                        Print(_file);
                    }
                    else
                        File.Delete(_file);
                }
                catch (Exception exx) { }

            }

            return "";
        }

        private static bool KillAdobe(string name)
        {
            foreach (Process clsProcess in Process.GetProcesses().Where(
                         clsProcess => clsProcess.ProcessName.StartsWith(name)))
            {
                clsProcess.Kill();
                return true;
            }
            return false;
        }

        public List<byte[]> getFileToMerge(HashSet<string> otid)
        {
            //string[] directory = Directory.GetDirectories(Globale_Varriables.VAR.pathFileUpload + @"\File\");
            List<byte[]> filesByte = new List<byte[]>();

            for (int i = 0; i < otid.Count; i++)
            {
                //for (int j = 0; j < directory.Length; j++)
                //{
                //if (Globale_Varriables.VAR.pathFileUpload + @"\File\" + otid.ElementAt(i) == directory[j])
                //{

                string path = Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid.ElementAt(i); // directory[j];
                IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
                foreach (string dir in dirList)
                {
                    string dpath = dir;
                    string[] type = dpath.Split('\\');
                    IEnumerable<string> fileList = System.IO.Directory.EnumerateFiles(dpath);

                    DataTable dt = Configs._query.executeProc("dev_getList", "parent@string@DocType#name@string@" + type[type.Length - 1]);
                    int nbr = 0;
                    if (Tools.verifyDataTable(dt)) nbr = Int32.Parse(dt.Rows[0]["filter"].ToString());

                    for (int cp = 1; cp <= nbr; cp++)
                    {
                        string[] files = Directory.GetFiles(dpath, "*.pdf");
                        foreach (string file in files)
                        {
                            try
                            {
                                byte[] bt = WriteToPdf(new FileInfo(file), otid.ElementAt(i));
                                filesByte.Add(bt);
                            }
                            catch (Exception ex)
                            {
                                Configs.Debug(ex.Message);
                            }
                        }
                    }
                }


                string[] _files = Directory.GetFiles(path, "*.pdf");
                foreach (string file in _files)
                {
                    try
                    {
                        byte[] bt = WriteToPdf(new FileInfo(file), otid.ElementAt(i));
                        filesByte.Add(bt);
                    }
                    catch
                    {
                    }
                }

                //}
                //}

            }

            return filesByte;
        }



        public void mergePdf(string otid)
        {
            string[] files = Directory.GetFiles(Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid, "*.pdf");
            List<byte[]> filesByte = new List<byte[]>();
            foreach (string file in files)
            {
                filesByte.Add(File.ReadAllBytes(file));
            }

            // Call pdf merger
            if (files.Length > 0)
            {
                // File.WriteAllBytes(Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid + @"\Global_PDF_" + otid + ".pdf", PDF.PdfMerger.MergeFiles(filesByte));
            }
            else
            {
                File.Create(Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid + @"\Global_PDF_" + otid + ".pdf");
            }
        }


        public void addImageToPDF(string otid)
        {
            string[] files = Directory.GetFiles(Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid, "*.jpg;*.png;*.gif;*.jpeg");

            Document doc = new Document();

            string pdfFilePath = Globale_Varriables.VAR.urlFileUpload + @"\File\" + otid + @"\Global_PDF_" + otid + ".pdf";
            PdfWriter pdfW = PdfWriter.GetInstance(doc, new FileStream(pdfFilePath, FileMode.Append));
            doc.Open();
            for (int i = 0; i < files.Length; i++)
            {
                iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(files[i]);
                img.ScaleToFit(280f, 260f);
                img.SpacingBefore = 30f;
                img.SpacingAfter = 1f;
                img.Alignment = Element.ALIGN_CENTER;
                doc.Add(img);
            }
            doc.Close();
        }


        public HashSet<string> getOTID(DataTable dt)
        {
            HashSet<string> returnHS = new HashSet<string>();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["PeriodeOTID"].ToString() != "0" && dt.Rows[i]["PeriodeOTID"].ToString() != "1" && dt.Rows[i]["PeriodeOTID"].ToString() != "-1")
                    returnHS.Add(dt.Rows[i]["PeriodeOTID"].ToString());
            }
            return returnHS;
        }


        public string generatePrestation(string otid)
        {
            string returnValue = "";
            try
            {
                for (int i = 0; i < this.dtPrestationPlan.Rows.Count; i++)
                {
                    if (dtPrestationPlan.Rows[i]["OTID"].ToString() == otid)
                    {
                        if (returnValue == "")
                            returnValue = dtPrestationPlan.Rows[i]["produit"].ToString() + "(" + dtPrestationPlan.Rows[i]["RefCmdClient"].ToString() + ")";
                        else

                            returnValue = returnValue + "\n" + dtPrestationPlan.Rows[i]["produit"].ToString() + "(" + dtPrestationPlan.Rows[i]["RefCmdClient"].ToString() + ")";

                    }
                }

                return returnValue;
            }
            catch
            {
                return "";
            }
        }

        public void CorrigerDataTable(DataTable dt)
        {
            try
            {
                string lastOtid = "";
                int cpt = 0;
                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    string otid = dt.Rows[i]["PeriodeOTID"].ToString();

                    if (lastOtid == "") lastOtid = otid;
                    if (otid == lastOtid)
                    {
                        cpt++;
                    }
                    else
                    {

                        if (lastOtid != "-1" && lastOtid != "1")
                        {
                            int prdInt = 1;
                            string periodes = dt.Rows[i - 1]["OTPeriodesNecessaires"].ToString();
                            try
                            {
                                prdInt = Convert.ToInt32(periodes);
                            }
                            catch
                            {
                                prdInt = 1;
                            }

                            if (cpt == prdInt)
                            {
                                cpt = 0;
                                i--;
                            }
                            else
                            {
                                int j = 0;
                                for (j = i - cpt; j < i; j++)
                                {
                                    dt.Rows[j]["OTPeriodesNecessaires"] = cpt;
                                }
                                cpt = 0;
                                i--;
                            }


                        }
                        else
                        {
                            cpt = 0;
                            i--;
                        }
                    }
                    lastOtid = otid;
                }
            }
            catch { }
        }

        public bool isNull(object value)
        {
            return value == null || DBNull.Value == value;
        }

        public void DataTableToPDF(DataTable dt, DataTable dtInfo, string pathh = "", string destPath = "")
        {
           


        }


        public void DataTableToPrint(DataTable dt, DataTable dtInfo, string pathh = "")
        {
            Document doc = new Document();
            try
            {
                //mergePdf("101004");

                // addImageToPDF("101004");

                string pdfFilePath = (pathh == "") ? Globale_Varriables.VAR.urlFileUpload + @"\File\" + dtInfo.Rows[0]["PlanID"].ToString() + "_" + Session["userID"].ToString() + ".pdf" : pathh;
                PdfWriter pdfW = PdfWriter.GetInstance(doc, new FileStream(pdfFilePath, FileMode.Create));

                this.dtPrestationPlan = this.getDtPlanPrestation(this.PlanID);

                doc.Open();

                float[] cellWidthEntete = { 40, 20, 40 };

                PdfPTable tableEntete = new PdfPTable(cellWidthEntete);
                tableEntete.TotalWidth = 550;
                tableEntete.LockedWidth = true;
                tableEntete.DefaultCell.BorderWidth = 0;

                string mntEncaise = "", totalPoid = "";
                if (dtInfo.Rows.Count > 0)
                {
                    mntEncaise = String.Format("{0:0.00}", (isNull(dtInfo.Rows[0]["TotalEncaissement"])) ? "0" : dtInfo.Rows[0]["TotalEncaissement"]);
                    totalPoid = String.Format("{0:0.00}", (isNull(dtInfo.Rows[0]["TotalPoids"])) ? "0" : dtInfo.Rows[0]["TotalPoids"]);
                    tableEntete.AddCell("Date du plan : " + Convert.ToDateTime(dtInfo.Rows[0]["PlanDate"].ToString()).ToString("dd/MM/yyyy"));
                    tableEntete.AddCell("");

                    string _remorque = "";
                    try
                    {
                        DataTable dtf = Configs._query.executeProc("PRC_getRemorque", "ID@int@" + dtInfo.Rows[0]["Remorque"].ToString());
                        if (dtf != null && dtf.Rows.Count > 0)
                        {
                            _remorque = dtf.Rows[0][0].ToString();
                        }
                    }
                    catch (Exception ex) { }


                    string type_tour = dtInfo.Rows[0]["Type_tournees"].ToString();
                    type_tour = (type_tour.IndexOf(":") > 0) ? (type_tour.Split(':')[0]) + dtInfo.Rows[0]["Position"].ToString() + " : " : "";

                    tableEntete.AddCell("PlanID : " + dtInfo.Rows[0]["PlanID"].ToString());
                    tableEntete.AddCell("Camion : " + dtInfo.Rows[0]["CODECAMION"].ToString() + " + Remorque" + ((Double.Parse((isNull(dtInfo.Rows[0]["TotalPoids"])) ? "0" : dtInfo.Rows[0]["TotalPoids"].ToString()) > 800) ? " + Remorque" : "") + ((_remorque != "") ? " (" + _remorque + ")" : ""));
                    tableEntete.AddCell("");
                    tableEntete.AddCell("Chauffeur : " + dtInfo.Rows[0]["CODECHAUFFEUR"].ToString());
                    tableEntete.AddCell("Remarque : " + type_tour + dtInfo.Rows[0]["PlanInstruction"].ToString());
                    tableEntete.AddCell("");



                    string aides = dtInfo.Rows[0]["AIDES"].ToString();
                    if (aides == null || aides == "")
                    {
                        tableEntete.AddCell("Aides : ");
                    }
                    else
                    {
                        tableEntete.AddCell("Aides : " + aides.Replace("@", '\n' + "            "));
                    }

                }



                doc.Add(tableEntete);

                doc.Add(new Phrase("               "));
                this.addHeader(doc, mntEncaise, totalPoid);
                doc.Add(new Phrase("               "));
                //this.addTabInfo(doc);

                //doc.Add(new Phrase("               "));


                float[] cellwidth = { 10, 16, 21, 19, 12, 3, 11, 13 };
                PdfPTable table = new PdfPTable(cellwidth);

                table.TotalWidth = 550;

                table.LockedWidth = true;
                var f = FontFactory.GetFont("Tahoma", 11, Font.NORMAL);
                f.Size = 8;

                table.DefaultCell.BorderWidth = 1;
                table.DefaultCell.BorderColor = new iTextSharp.text.BaseColor(0, 0, 0);

                //  table.HeaderRows = 20;

                this.generateEntetTable(table);

                string valueCell = "", lasteOTID = "";
                CorrigerDataTable(dt);
                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    string otid = dt.Rows[i]["PeriodeOTID"].ToString();
                    string periodes = dt.Rows[i]["OTPeriodesNecessaires"].ToString();


                    int nbrPeriode;
                    try
                    {
                        nbrPeriode = Convert.ToInt32(periodes);
                    }
                    catch
                    {
                        nbrPeriode = 1;
                    }

                    string lim = dt.Rows[i]["toHour"].ToString();
                    lim = (DBNull.Value.Equals(lim) || lim == null || lim == "") ? "" : ("\r\nLim. " + lim);
                    string heure = dt.Rows[i]["Heures"].ToString();
                    string NOBL = dt.Rows[i]["No Bulletin"].ToString() + lim;
                    string CLIENT = dt.Rows[i]["Nom du client"].ToString();
                    string lientLiv = dt.Rows[i]["Lieu de livraison"].ToString();
                    string code = dt.Rows[i]["Code"].ToString();
                    string n = dt.Rows[i]["N"].ToString();
                    string somme = dt.Rows[i]["Somme"].ToString();
                    string note = dt.Rows[i]["OTNoteInterne"].ToString();


                    try
                    {
                        string charg = dt.Rows[i]["Clieu_chargement"].ToString();
                        if (charg.Length > 2)
                        {
                            string tmpcode = dt.Rows[i]["OTLieuChargement"] + " " + dt.Rows[i]["np_chargement"] + "," + dt.Rows[i]["ville_chargement"];
                            if (tmpcode.Length > 3)
                                code += "  " + tmpcode;
                        }
                    }
                    catch (Exception exc) { }

                    //if (NOBL == "" || NOBL == "bloquer") NOBL = "-"; else NOBL = NOBL + "\n" + this.generatePrestation(otid);
                    //if (CLIENT == "") CLIENT = "-";
                    //if (lientLiv == "") lientLiv = "-";
                    //if (code == "") code = "-";
                    //if (n == "") n = "-";
                    //if (somme == "") somme = "0.00";

                    try
                    {
                        heure = Convert.ToDateTime(heure).ToString("HH:mm") + "\n\n";
                    }
                    catch { heure = "-"; };

                    PdfPCell cell;



                    NOBL = NOBL + "\n" + this.generatePrestation(otid);

                    cell = new PdfPCell(new Phrase(heure, f));
                    table.AddCell(cell);

                    if (lasteOTID != otid || otid == "-1" || otid == "1")
                    {
                        cell = new PdfPCell(new Phrase(NOBL, f));
                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_LEFT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);

                        cell = new PdfPCell(new Phrase(CLIENT, f));
                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_LEFT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);

                        cell = new PdfPCell(new Phrase(lientLiv, f));
                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_LEFT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);

                        cell = new PdfPCell(new Phrase(code, f));



                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_LEFT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);

                        cell = new PdfPCell(new Phrase(n, f));
                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);

                        PdfPCell celll = new PdfPCell(new Phrase(note, f));
                        celll.Rowspan = nbrPeriode;
                        celll.HorizontalAlignment = Element.ALIGN_CENTER;
                        celll.VerticalAlignment = Element.ALIGN_MIDDLE;
                        //celll.Phrase.Font.Size = 5.0f;
                        table.AddCell(celll);

                        cell = new PdfPCell(new Phrase(String.Format("{0:0.00}", MCV.MyConvert.ToDouble(somme)), f));
                        cell.Rowspan = nbrPeriode;
                        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                        table.AddCell(cell);
                    }
                    lasteOTID = otid;

                    //for (int j = 0; j < dt.Columns.Count-2; j++)
                    //{
                    //    valueCell = "";
                    //    if (j == 0)
                    //    {
                    //        try
                    //        {
                    //            valueCell = Convert.ToDateTime(dt.Rows[i][j].ToString()).ToString("HH:mm") + "\n\n";
                    //        }
                    //        catch { valueCell = "-"; };
                    //    }
                    //    else if(j==6)
                    //    {
                    //        valueCell = String.Format("{0:0.00}", dt.Rows[i][j]);
                    //    }
                    //    else
                    //    {
                    //        valueCell = dt.Rows[i][j].ToString();
                    //    }
                    //    PdfPCell cell = new PdfPCell(new Phrase(valueCell,f));

                    //    if (j > 3)
                    //    {
                    //        cell.HorizontalAlignment = Element.ALIGN_RIGHT ;
                    //        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                    //    }
                    //    else
                    //    {
                    //        cell.HorizontalAlignment = Element.ALIGN_LEFT;
                    //        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
                    //    }
                    //    table.AddCell(cell);
                    //  cell = new PdfPCell(new Phrase("",f));
                    //}
                }

                //doc.Add(new Phrase("                    "));

                //doc.Add(new Phrase("                    "));
                doc.Add(table);
                // doc.Add(new Phrase("               "));


                doc.Close();

                Print(pdfFilePath);

                /*
                List<byte[]> listePdfToMerge = this.getFileToMerge(getOTID(dt));
                listePdfToMerge.Insert(0, File.ReadAllBytes(pdfFilePath));
                Random random = new Random();
                int num = random.Next(1000);
                // Session["userID"].ToString()
                File.WriteAllBytes(Globale_Varriables.VAR.pathApplication + @"\File\" + dtInfo.Rows[0]["PlanID"].ToString() + "_" + Session["userID"].ToString() + ".pdf", PDF.PdfMerger.MergeFiles(listePdfToMerge));
                */
                //file:///C:/PDF
                //string redirctPath = "http://192.168.1.15/preuves/" + Session["userID"] + ".pdf";

                string newFilePrint = Globale_Varriables.VAR.urlFileUpload + @"\File\" + dtInfo.Rows[0]["PlanID"].ToString() + "_" + Session["userID"].ToString() + "_{0}.pdf";

                string res = getFileToPrint(getOTID(dt), newFilePrint);


                //KillAdobe("AcroRd32");
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "Print PDF");
                doc.Close();
            }
        }

        private void Print(string file)
        {
            try
            {
                //AxAcroPDFLib.AxAcroPDF pdf = new AxAcroPDFLib.AxAcroPDF();
                //pdf.src = file;
                //pdf.printAll();

                //Thread.Sleep(5000);
            }
            catch (Exception ex)
            {

                Configs.Debug(ex, "Print Process");
            }
        }

        public void generateEntetTable(PdfPTable table)
        {
            PdfPCell cell = new PdfPCell(new Phrase("Heures"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;

            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("No Bulletin"));


            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;

            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Nom du Client"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;

            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Chargement"));
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Livraison"));
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Code"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("N"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Note"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Somme"));

            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);



        }

        public void addHeader(Document doc, string totalEncaissement, string totalPoid)
        {


            float[] sizeLine1 = { 25, 18, 5, 13, 39 };
            PdfPTable table = new PdfPTable(sizeLine1);
            table.TotalWidth = 550;
            table.LockedWidth = true;
            table.DefaultCell.Border = 0;


            table.AddCell("Total encaissements : ");


            PdfPCell cell = new PdfPCell(new Phrase(totalEncaissement));
            cell.Border = 1;
            cell.BackgroundColor = iTextSharp.text.BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);
            table.AddCell("");
            cell = new PdfPCell(new Phrase("Total Poids : "));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.Border = 0;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(totalPoid));
            cell.Border = 1;
            cell.BackgroundColor = iTextSharp.text.BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            iTextSharp.text.Image jpg = iTextSharp.text.Image.GetInstance(Globale_Varriables.VAR.PathCont + "/template/choix_0.png");
            jpg.ScaleAbsolute(14f, 14f);

            float[] size2 = { 25f, 18f, 18f, 39f };

            PdfPTable table2 = new PdfPTable(size2);
            table2.TotalWidth = 550;
            table2.LockedWidth = true;

            table2.AddCell("Carburant consommation");
            table2.AddCell("KM parcourus");
            //table2.AddCell("Encaissements");
            table2.AddCell("Décompte des heures");

            Phrase phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" N° : C+R"));
            table2.AddCell(phrase);


            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" Plein Garage Perroy"));

            //Ligne1
            table2.AddCell(phrase); //"   Plein Garage Perroy");
            table2.AddCell("Km arrivé :"); ///FIX 1
            //table2.AddCell("Liquide : CHF ........");
            table2.AddCell("H.Départ :");


            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" Noms chauffeur + aide chauffeur "));
            table2.AddCell(phrase);


            //Ligne2

            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" Plein exterieur"));

            table2.AddCell(phrase);
            table2.AddCell("KM départ :");   ///FIX 1
            //table2.AddCell("CC      : CHF ........");
            table2.AddCell("H.Arrivé :");

            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" BL signés"));
            table2.AddCell(phrase);

            //Ligne3
            table2.AddCell(".................. Litres");
            table2.AddCell("Km parcourus :");
            //table2.AddCell("Chéque  : CHF ........");
            table2.AddCell("");

            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" Retours identifiés sur plan ID + code stock indiqué"));
            table2.AddCell(phrase);

            //Ligne4
            table2.AddCell(".................. CHF");
            table2.AddCell("Visa chauffeur");
            //table2.AddCell("Visa débriefing");
            table2.AddCell("Décompte :");

            phrase = new Phrase();
            phrase.Add(new Chunk(jpg, -1, -1));
            phrase.Add(new Chunk(" SAMS identifiés + personne de contact indiquée"));
            table2.AddCell(phrase);

            //Ligne5
            /*
            table2.AddCell("P.Pneu avant :");
            table2.AddCell("P.Pneu arriére :");
            table2.AddCell("");
            table2.AddCell("");
            */

            doc.Add(table);

            //doc.Add(table2);
        }


        public void addTabInfo(Document doc)
        {
            /*
            float[] size2 = { 55f, 45f };

            PdfPTable table2 = new PdfPTable(size2);
            table2.TotalWidth = 550;
            table2.LockedWidth = true;

            table2.AddCell("N° : C+R");
            table2.AddCell(" ");

            table2.AddCell("Si affrété, nom de la personne complété : ");
            table2.AddCell(" ");

            table2.AddCell("Les bulletins correspondent au plan ID et sont signés : ");
            table2.AddCell(" ");

            table2.AddCell("Retours identifiés sur plan ID + code stock indiqué : ");
            table2.AddCell(" ");

            table2.AddCell("SAMS identifiés + personne de contact indiquée : ");
            table2.AddCell(" ");

            doc.Add(table2);*/
        }

    }
    public static class FooTheoryMath
    {
        public static double GetHypotenuseAngleInDegreesFrom(double opposite, double adjacent)
        {

            double radians = Math.Atan2(opposite, adjacent); // Get Radians for Atan2
            double angle = radians * (180 / Math.PI); // Change back to degrees
            return angle;
        }
    }	
}