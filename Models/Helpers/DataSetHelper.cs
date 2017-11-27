using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data;
using System.IO;
using ExcelLibrary.SpreadSheet;
using System.Drawing;

namespace TRC_GS_COMMUNICATION.Models
{
    public sealed class DataSetHelper
    {
        public static DataSet CreateDataSet(String filePath)
        {
            DataSet ds = new DataSet();
            Workbook workbook = Workbook.Load(filePath);
            foreach (Worksheet ws in workbook.Worksheets)
            {
                DataTable dt = PopulateDataTable(ws);
                ds.Tables.Add(dt);
            }
            return ds;
        }

        public static DataTable CreateDataTable(String filePath, String sheetName)
        {
            Workbook workbook = Workbook.Load(filePath);
            foreach (Worksheet ws in workbook.Worksheets)
            {
                if (ws.Name.Equals(sheetName))
                    return PopulateDataTable(ws);
            }
            return null;
        }

        private static DataTable PopulateDataTable(Worksheet ws)
        {
            CellCollection Cells = ws.Cells;

            DataTable dt = new DataTable(ws.Name);

            for (int i = 0; i <= Cells.LastColIndex; i++)
                dt.Columns.Add(Cells[0, i].StringValue, typeof(String));

 
            for (int currentRowIndex = 1; currentRowIndex <= Cells.LastRowIndex; currentRowIndex++)
            {
                DataRow dr = dt.NewRow();
                for (int currentColumnIndex = 0; currentColumnIndex <= Cells.LastColIndex; currentColumnIndex++)
                    dr[currentColumnIndex] = Cells[currentRowIndex, currentColumnIndex].StringValue;
                dt.Rows.Add(dr);
            }

            return dt;
        }


        public static void CreateWorkbook(String filePath, DataSet dataset)
        {
            if (dataset.Tables.Count == 0)
                throw new ArgumentException("DataSet needs to have at least one DataTable", "dataset");

            CellStyle style = new CellStyle();
           style.BackColor = Color.Yellow;


            Workbook workbook = new Workbook();
            foreach (DataTable dt in dataset.Tables)
            {
                Worksheet worksheet = new Worksheet(dt.TableName);
                for (int i = 0; i < dt.Columns.Count; i++)
                {

                    Cell cell = new Cell(dt.Columns[i].ColumnName);
                    cell.Style = style;
                    worksheet.Cells[0, i] = cell;

                    for (int j = 0; j < dt.Rows.Count; j++)
                        worksheet.Cells[j + 1, i] = new Cell(dt.Rows[j][i]);
                }
                workbook.Worksheets.Add(worksheet);
            }
            workbook.Save(filePath);
        }

        public static void CreateWorkbookCSV(String filePath, DataTable dt)
        {

            if (File.Exists(filePath))
            {
                try
                {
                    File.Delete(filePath);
                }
                catch (Exception ex) { }
            }

            StreamWriter sr = new StreamWriter(filePath, false, System.Text.Encoding.GetEncoding("iso-8859-1"));
            string values = "";
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                values += dt.Columns[i].ColumnName + ";";
            }
            if (values.Length > 0) values = values.Substring(0, values.Length - 1);
            sr.WriteLine(values);
            sr.Flush();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                values = "";

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    values += dt.Rows[i][j].ToString() + ";";
                }

                if (values.Length > 0) values = values.Substring(0, values.Length - 1);
                sr.WriteLine(values);
                sr.Flush();
            }

            sr.Close();
        }
    }
}