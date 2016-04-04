using System;
using System.Drawing;
using System.IO;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


    }



    protected void Button1_Click(object sender, EventArgs e)
    {
        char s = 'F';
        if (sex.SelectedIndex == 0) s = 'M';
        Response.Redirect("/Sign-Up?s=" + s);
    }
}