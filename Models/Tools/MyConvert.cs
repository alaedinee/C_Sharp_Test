using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MCV
{
    public static class MyConvert
    {


        public static Int32 ToInt32(object value)
        {
            
            try
            {
                return Convert.ToInt32(Convert.ToDouble(value));
            }
            catch
            {
                return 0;
            }

        }

        public static Int64 ToInt64(object value)
        {

            try
            {
                return Convert.ToInt64(Convert.ToDouble(value));
            }
            catch
            {
                return 0;
            }

        }
        
        public static string ToDoubleString(object val)
        {
            try
            {
                if (val is DBNull) return "0.00";
                if (val == null) return "0.00";
                if (val.ToString().Trim(' ') == "") return "0.00";

                return String.Format("{0:0.00}", Convert.ToDouble(val.ToString())).Replace(",",".");

            }
            catch
            {
                return "0.00";
            }
        }

        public static double ToDouble(object val)
        {
            try
            {
                if (val is DBNull) return 0.00;
                if (val == null) return 0.00;
                if (val.ToString().Trim(' ') == "") return 0.00;
                try
                {
                    return Convert.ToDouble(String.Format("{0:0.00}", Convert.ToDouble(val.ToString())));
                }
                catch
                {
                    return Convert.ToDouble(String.Format("{0:0.00}", Convert.ToDouble(val.ToString().Replace(".", ","))));
                }

            }
            catch
            {
                return 0.00;
            }
        }

        public static Double _ToDouble(string str)
        {
            if (str == null || str == "")
                return 0;

            Double result = 0;
            try
            {
                result = Double.Parse(str.Replace(".", ","));

            }
            catch (Exception ex)
            {
                result = Double.Parse(str.Replace(",", "."));
            }
            return Math.Round(result, 2);
        }

        public static DateTime ToDateTime(object value)
        {
            try
            {
                return Convert.ToDateTime(value);
            }
            catch
            {
                return Convert.ToDateTime(DateTime.Now.AddYears(-1000));
            }
        }

        public static string ToDateTimeString(object value, string format)
        {
            try
            {
                if (isDate(value)) return Convert.ToDateTime(value).ToString(format);
                else return "";
            }
            catch
            {
                return "";
            }
        }

        public static bool IsDouble(object value)
        {
            try
            {
                 Convert.ToDouble(value);
                 return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static Boolean isDate(object value)
        {
            try
            {
                Convert.ToDateTime(value);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static Boolean isInt(object value)
        {
            try
            {
                Convert.ToInt64(value);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static Boolean isNumeric(object value)
        {
            try
            {
                char crt = ' ';
                //if (value.ToString().Contains(","))
                //{
                //    crt = ',';
                //}
                if (value.ToString().Contains("."))
                {
                    crt = '.';
                }
                else if (isInt(value))
                {
                    return true;
                }
                string[] t = value.ToString().Split(crt);
                if (t.Length == 2 && isInt(t[0]) && isInt(t[1]))
                {
                    return true;
                }
                else
                {
                    return false;
                }


            }
            catch (Exception ex)
            {
                return false;
            }
        }


    }
}
