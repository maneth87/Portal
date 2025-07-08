using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for bl_ecert
/// </summary>
public class bl_ecert
{
	public bl_ecert()
	{
		//
		// TODO: Add constructor logic here
		//
	}
   public Int32 ID { get; set; }
   public string CustomerNameKh { get; set; }
   public string CustomerNameEn { get; set; }
   public DateTime CustomerDob { get; set; }
   public string CustomerGender { get; set; }
   public string CertificateNumber { get; set; }
   public DateTime EffectiveDate { get; set; }
   public DateTime ExpiryDate { get; set; }
   public DateTime MaturityDate { get; set; }
   public Int32 Status { get; set; }
   public string CreatedBy { get; set; }
   public DateTime CreatedOn { get; set; }
   public string CreatedRemarks { get; set; }
   public string UpdatedBy { get; set; }
   public DateTime UpdatedOn { get; set; }
   public string UpdatedRemarks { get; set; }
   public string Remarks { get; set; }
   public string Owner { get; set; }
}