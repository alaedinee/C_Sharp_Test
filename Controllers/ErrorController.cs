﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class ErrorController : Controller
    {
        //
        // GET: /Error/

        public string Index()
        {
            return "Bad request";
        }

    }
}
