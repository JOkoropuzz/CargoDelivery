using Microsoft.Web.WebView2.Core;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Xml.Linq;
using static System.Net.Mime.MediaTypeNames;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для Map.xaml
    /// </summary>
    public partial class Map : Window
    {
        public Map()
        {
            InitializeComponent();
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            this.Visibility = Visibility.Hidden;
        }

        public string resaultAddress;

        async private void getaddressbtn_Click(object sender, RoutedEventArgs e)
        {
            string address = "";
            string html = await webView.ExecuteScriptAsync("document.documentElement.outerHTML;");
            string[] words = html.Split(new char[] { '>' });
            foreach (string s in words)
            {
                if (s.Contains(",&nbsp;") && s.Contains("\\u003C/"))
                    address += (s + "\n");
            }
            words = address.Split(new char[]{'\n'});
            if (words.Length > 2) { MessageBox.Show("Некоректный адресс!"); }
            else 
                {
                address = words[0].Replace("&nbsp;", " ").Replace("\\u003C/", "").Replace("span", "");
                if (address is "") { MessageBox.Show("Некорректный адресс!");  }
                else
                {
                    resaultAddress = address;
                    this.DialogResult = true;
                }
            }
        }

    }
}
