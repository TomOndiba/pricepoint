using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_ConfirmUnlock : System.Web.UI.Page
{
    public int cr;
    public string user;
    protected void Page_Load(object sender, EventArgs e)
    {
        DB_Helper db = new DB_Helper();
        int id = Convert.ToInt32(Request.QueryString["id"]);

        DataSet ds= db.GetDataSet("select dbo.CalculateCredits2Unlock(amount) as credits from offers  where (id_user_from=" + id + " and id_user_to=" + MyUtils.ID_USER + ") or (id_user_from=" + MyUtils.ID_USER + " and id_user_to=" + id + ");select username from users where id_user=" + id);
        cr = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        user = Convert.ToString(ds.Tables[1].Rows[0][0]);

        bool not_enough_credits = cr > MyUtils.Credits;

        nocredits.Visible = not_enough_credits;
        confirm.Visible = !nocredits.Visible;

    }
}