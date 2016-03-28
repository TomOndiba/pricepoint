using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserPersonnalData : System.Web.UI.UserControl
{
    public string dlClass { get; set; }

    public List<Tuple<string,string>> userData { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        rptUserData.DataSource = userData;
        rptUserData.DataBind();
    }
}