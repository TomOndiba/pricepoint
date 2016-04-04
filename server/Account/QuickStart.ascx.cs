using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_QuickStart : System.Web.UI.UserControl
{
    public string Title { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        this.his.Visible = MyUtils.IsMale;
        this.her.Visible = MyUtils.IsFemale;
    }
}