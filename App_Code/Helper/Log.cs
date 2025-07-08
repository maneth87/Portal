using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Log
/// </summary>
public class Log
{
	public Log()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static void AddExceptionToLog(string MessageIN)
    {
        DateTime dt = DateTime.Now;
        string filePath = AppDomain.CurrentDomain.BaseDirectory + "Log\\log_" + dt.ToString("yyyy-MM-dd") + ".log";
        if (!File.Exists(filePath))
        {
            FileStream fs = File.Create(filePath);
            fs.Close();
        }
        try
        {
            StreamWriter sw = File.AppendText(filePath);
            if (!string.IsNullOrEmpty(MessageIN))
            {
                sw.WriteLine(dt.ToString("HH:mm:ss") + "   " + MessageIN + System.Environment.NewLine);
            }
            else
            {
                sw.WriteLine(dt.ToString("HH:mm:ss") + "   " + MessageIN + System.Environment.NewLine);
            }

            sw.Flush();
            sw.Close();

        }
        catch (Exception ex)
        {
        }
    }
}