using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;
using iTextSharp.text.pdf;
using System.Text;
using iTextSharp.text;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{
    public class PDFMerger
    {
        public static List<byte[]> getFileToMerge(HashSet<string> otid)
        {
            //string[] directory = Directory.GetDirectories(Globale_Varriables.VAR.pathFileUpload + @"\File\");
            List<byte[]> filesByte = new List<byte[]>();

            for (int i = 0; i < otid.Count; i++)
            {
                //for (int j = 0; j < directory.Length; j++)
                //{
                //if (Globale_Varriables.VAR.pathFileUpload + @"\File\" + otid.ElementAt(i) == directory[j])
                //{

                string path = Globale_Varriables.VAR.PATH_STOCKAGE + otid.ElementAt(i) + @"\"; // directory[j];
                if (!Directory.Exists(path)) continue;
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
                                Omniyat.Models.Configs.Debug(ex.Message);
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
        public static List<byte[]> getFileToMerge(HashSet<string> otids, string tempName, string ids = null, bool withDetail = false)
        {
            List<byte[]> filesByte = new List<byte[]>();

            for (int i = 0; i < otids.Count; i++)
            {
                string param = "name@string@" + tempName;
                if(ids != null)
                    param += "#ids@string@"+ids;
                DataTable dt = Configs._query.executeProc("RDV_getFilesTemplate", param);

                string[] tab = otids.ElementAt(i).Split(new char[]{','});
                if(tab.Length < 1) continue;
                string idOT = tab[0];

                foreach (DataRow r in dt.Rows)
                {
                    string path = Globale_Varriables.VAR.PATH_STOCKAGE + idOT + r["Directory"].ToString();
                    if (!Directory.Exists(path)) continue;
                    try
                    {
                        IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
                        string[] _files = Directory.GetFiles(path, r["FilesFilter"].ToString());
                        foreach (string file in _files)
                        {
                            try
                            {
                                byte[] bt = WriteToPdf(new FileInfo(file), idOT);
                                filesByte.Add(bt);
                            }
                            catch { }
                        }
                    }
                    catch {}
                }
                // get files of Groupe
                if (withDetail && tab.Length > 1 && tab[1].Length >= 3)
                {
                    HashSet<string> otidsGroupe = getOTIDsGroupe(idOT);
                    List<byte[]> filesByteGroup = getFileToMerge(otidsGroupe, tempName, ids, false);
                    filesByte.AddRange(filesByteGroup);
                }
            }

            return filesByte;
        }

        private static HashSet<string> getOTIDsGroupe(string idOT)
        {
            HashSet<string> lst = new HashSet<string>();
            DataTable dt = Configs._query.executeProc("OT_GetOTByGroup", "OTIDGroup@int@" + idOT);
            if (!Tools.verifyDataTable(dt))
                return lst;
            foreach (DataRow r in dt.Rows)
                if(!lst.Contains(r["OTID"].ToString()))
                    lst.Add(r["OTID"].ToString());
            return lst;
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
        ////////////////////////////////////////////////////////////////////////////////////
        public static byte[] MergeFiles(List<byte[]> sourceFiles)
        {
            Document document = new Document();
            MemoryStream output = new MemoryStream();
            try
            {
                try
                {
                    // Initialize pdf writer
                    PdfWriter writer = PdfWriter.GetInstance(document, output);
                    writer.PageEvent = new PdfPageEvents();

                    // Open document to write
                    document.Open();
                    PdfContentByte content = writer.DirectContent;

                    // Iterate through all pdf documents
                    for (int fileCounter = 0; fileCounter < sourceFiles.Count; fileCounter++)
                    {
                        // Create pdf reader
                        PdfReader reader = new PdfReader(sourceFiles[fileCounter]);
                        int numberOfPages = reader.NumberOfPages;

                        // Iterate through all pages
                        for (int currentPageIndex = 1; currentPageIndex <= numberOfPages; currentPageIndex++)
                        {
                            // Determine page size for the current page
                            document.SetPageSize(reader.GetPageSizeWithRotation(currentPageIndex));
                            // Create page
                            document.NewPage();
                            PdfImportedPage importedPage = writer.GetImportedPage(reader, currentPageIndex);
                            // Determine page orientation
                            int pageOrientation = reader.GetPageRotation(currentPageIndex);
                            if ((pageOrientation == 90) || (pageOrientation == 270))
                            {
                                content.AddTemplate(importedPage, 0, -1f, 1f, 0, 0, reader.GetPageSizeWithRotation(currentPageIndex).Height);
                            }
                            else
                            {
                                content.AddTemplate(importedPage, 1f, 0, 0, 1f, 0, 0);
                            }
                        }
                    }
                }
                catch (Exception exception)
                {
                    throw new Exception("There has an unexpected exception occured during the pdf merging process.", exception);
                }
            }
            finally
            {
                document.Close();
            }

            return output.GetBuffer();
        }

    }

    /// <summary>
    /// Implements custom page events.
    /// </summary>
    internal class PdfPageEvents : IPdfPageEvent
    {
        #region members

        private BaseFont _baseFont = null;
        private PdfContentByte _content;

        #endregion

        #region IPdfPageEvent Members

        public void OnOpenDocument(PdfWriter writer, Document document)
        {
            _baseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            _content = writer.DirectContent;
        }

        public void OnStartPage(PdfWriter writer, Document document)
        {
        }

        public void OnEndPage(PdfWriter writer, Document document)
        {
            // Write header text
            string headerText = "";
            _content.BeginText();
            _content.SetFontAndSize(_baseFont, 8);
            _content.SetTextMatrix(GetCenterTextPosition(headerText, writer), writer.PageSize.Height - 10);
            _content.ShowText(headerText);
            _content.EndText();

            // Write footer text (page numbers)
            string text = "Page " + writer.PageNumber;
            _content.BeginText();
            _content.SetFontAndSize(_baseFont, 8);
            _content.SetTextMatrix(GetCenterTextPosition(text, writer), 10);
            _content.ShowText(text);
            _content.EndText();
        }

        public void OnCloseDocument(PdfWriter writer, Document document)
        {
        }

        public void OnParagraph(PdfWriter writer, Document document, float paragraphPosition)
        {
        }

        public void OnParagraphEnd(PdfWriter writer, Document document, float paragraphPosition)
        {
        }

        public void OnChapter(PdfWriter writer, Document document, float paragraphPosition, Paragraph title)
        {
        }

        public void OnChapterEnd(PdfWriter writer, Document document, float paragraphPosition)
        {
        }

        public void OnSection(PdfWriter writer, Document document, float paragraphPosition, int depth, Paragraph title)
        {
        }

        public void OnSectionEnd(PdfWriter writer, Document document, float paragraphPosition)
        {
        }

        public void OnGenericTag(PdfWriter writer, Document document, Rectangle rect, string text)
        {
        }

        #endregion

        private float GetCenterTextPosition(string text, PdfWriter writer)
        {
            return writer.PageSize.Width / 2 - _baseFont.GetWidthPoint(text, 8) / 2;
        }
    }
}