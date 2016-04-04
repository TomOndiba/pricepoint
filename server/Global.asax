<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        string JQueryVer = "2.2.0";
        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "/js/vendor/jquery.min.js",
            DebugPath = "/js/vendor/jquery.min.js",
            CdnPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".min.js",
            CdnDebugPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".js",
            CdnSupportsSecureConnection = true,
            LoadSuccessExpression = "window.jQuery"
        });
        RWorker.StartSqlPollingBackgroundWorker();
    }


    void Application_End(object sender, EventArgs e)
    {
        RWorker.StopSqlPollingBackgroundWorker();
    }


    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }


    void Application_BeginRequest(object sender, EventArgs e)
    {
        System.Web.HttpContext context = System.Web.HttpContext.Current;

        String fullOrigionalpath = context.Request.Url.ToString();

        if (!context.Items.Contains("OriginalRawUrl"))
        {
            context.Items["OriginalRawUrl"] = fullOrigionalpath;
        }


        if (fullOrigionalpath.Contains("/Account/Dates"))
        {
            Context.RewritePath("/Account/Offers.aspx?type=Accepted&dates=1");
            return;
        }

        Uri u = new Uri(fullOrigionalpath);
        if (!u.AbsolutePath.EndsWith(".aspx") && !u.AbsolutePath.EndsWith(".asmx"))
        {
            string file = Server.MapPath("~"+u.AbsolutePath) + ".aspx";
            if (MyUtils.FastFileExist(file))
                Context.RewritePath(u.AbsolutePath+".aspx" + u.Query);
        }

    }

</script>
