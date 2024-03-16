using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Npgsql;
using System.Data.Entity.Core.Objects;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using System.Data.OleDb;
using Devart.Data.PostgreSql;
using System.Reflection.Emit;
using System.Numerics;
using System.Diagnostics.Eventing.Reader;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public CreateOrder newOrder { get; set; }

        public MainWindow()
        {
            InitializeComponent();
            
        }

        private void createorderbtn_Click_1(object sender, RoutedEventArgs e)
                {
                    
                    newOrder = new CreateOrder();
                    newOrder.Owner = MainWin1;
                    newOrder.Show();
                }

        private void findorderbtn_Click(object sender, RoutedEventArgs e)
        {
            NpgsqlConnection conn = new NpgsqlConnection();
            LogInWin.getConnection(conn, LogInWin.connstring);
            string idorder;
            string lastname;
            string phone;
            if (idordertb.Text == "")
            { idorder = "null"; }
            else { idorder = idordertb.Text; };
            if (lastnametb.Text == "")
            { lastname = "null"; }
            else{ lastname = "'" + lastnametb.Text + "'"; };
            if (phonenumbertb.Text == "")
            { phone = "null"; }
            else { phone = "'"+phonenumbertb.Text+"'"; };
            string command = ("select * from orderview(" + idorder + ", " + phone + ", " + lastname + ");");
            var dataAdapter = new NpgsqlDataAdapter(command, conn);
            var table = new DataTable();
            dataAdapter.Fill(table);
            dg1.ItemsSource = table.DefaultView;
            conn.Close();
        }
    }
}
