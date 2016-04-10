using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_BirthdayCtrl : System.Web.UI.UserControl
{
    public bool IsRegistration = false;
    public void SetBirthday(DateTime dt)
    {
        ddlYear.SelectedValue = dt.Year.ToString();
        ddlMonth.SelectedValue = dt.Month.ToString();
        ddlDay.SelectedValue = dt.Day.ToString();
    }

    public DateTime GetBirthday(out string error)
    {
        error = "";
        int year, month, day;
        if (!int.TryParse(ddlYear.SelectedValue, out year) || !int.TryParse(ddlMonth.SelectedValue, out month) || !int.TryParse(ddlDay.SelectedValue, out day))
        {
            error = "Birthday is required.";
            return DateTime.MinValue;
        }

        try
        {
            DateTime dt = new DateTime(year, month, day);
            if (DateTime.Now < dt.AddYears(18))
            {
                error = "You must be 18 years or older to sign up. ";
                return DateTime.MinValue;
            }

            return dt;
        }
        catch (ArgumentOutOfRangeException ex)
        {
            error = "Incorrect birthday date. " + ex.Message;
            return DateTime.MinValue;
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
//        ddlMonth.Items.Add("Month");
        List<string> monthNames = DateTimeFormatInfo.CurrentInfo.MonthNames.Take(12).ToList();
        ddlMonth.Items.AddRange(monthNames.Select(m => new ListItem { Value = (monthNames.IndexOf(m) + 1).ToString(), Text = m }).ToArray());

  //      ddlDay.Items.Add("DD");
        for (int i = 1; i <= 31; i++)
            ddlDay.Items.Add(new ListItem(i.ToString(), i.ToString()));

    //    ddlYear.Items.Add("YYYY");
        for (int i = DateTime.Now.Year-17; i >= 1920; i--)
            ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));

        ddlYear.SelectedValue = (DateTime.Now.Year-25).ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsRegistration)
        {
            ddlDay.Enabled = false;
            ddlYear.Enabled = false;
            ddlMonth.Enabled = false;
        }
    }
}