using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;

public class EmailSender
{
    /// <summary>
    /// Sends an mail message
    /// </summary>
    /// <param name="from">Sender address</param>
    /// <param name="recepient">Recepient address</param>
    /// <param name="subject">Subject of mail message</param>
    /// <param name="body">Body of mail message</param>
    public static void SendMailMessage(string @from, string recepient, string bcc_recepient, string subject, string body)
    {
        // Instantiate a new instance of MailMessage
        MailMessage mMailMessage = new MailMessage();

        // Set the sender address of the mail message
        mMailMessage.From = new MailAddress(@from);
        // Set the recepient address of the mail message
        mMailMessage.To.Add(new MailAddress(recepient));

        //'multiple attachment
        //For j As Integer = 0 To ary.Count - 1
        //    mMailMessage.Attachments.Add(ary(j))
        //Next j


        // Check if the bcc value is nothing or an empty string
        if ((bcc_recepient != null) & bcc_recepient != string.Empty)
        {
            // Set the Bcc address of the mail message
            mMailMessage.Bcc.Add(new MailAddress(bcc_recepient));
        }

        //' Check if the cc value is nothing or an empty value
        //If Not cc Is Nothing And cc <> String.Empty Then
        //    ' Set the CC address of the mail message
        //    mMailMessage.CC.Add(New MailAddress(cc))
        //End If

        // Set the subject of the mail message
        mMailMessage.Subject = subject;
        // Set the body of the mail message
        mMailMessage.Body = body;

        // Set the format of the mail message body as HTML
        mMailMessage.IsBodyHtml = true;
        // Set the priority of the mail message to normal
        mMailMessage.Priority = MailPriority.Normal;

        mMailMessage.BodyEncoding = System.Text.Encoding.GetEncoding("utf-8");

        System.Net.Mail.AlternateView plainView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(mMailMessage.Body, null, "text/plain");
        plainView.TransferEncoding = System.Net.Mime.TransferEncoding.QuotedPrintable;

        System.Net.Mail.AlternateView htmlView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(mMailMessage.Body, null, "text/html");
        htmlView.TransferEncoding = System.Net.Mime.TransferEncoding.QuotedPrintable;

        mMailMessage.AlternateViews.Add(plainView);
        mMailMessage.AlternateViews.Add(htmlView);


        // Instantiate a new instance of SmtpClient
        SmtpClient mSmtpClient = new SmtpClient();
        // Send the mail message
        mSmtpClient.Send(mMailMessage);
    }
}