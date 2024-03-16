using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.OleDb;
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
using System.Windows.Shapes;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для CreateOrder.xaml
    /// </summary>
    public partial class CreateOrder : Window
    {
        public CreateOrder()
        {
            InitializeComponent();
        }

        private void loadingmapbtn_Click(object sender, RoutedEventArgs e)
        {
            Map loadMap = new Map();
            if (loadMap.ShowDialog() == true) loadingaddressbtn.Text = loadMap.resaultAddress;
        }

        private void deliverymapbtn_Click(object sender, RoutedEventArgs e)
        {
            Map deliveryMap = new Map();
            if (deliveryMap.ShowDialog() == true) deliveryaddresstb.Text = deliveryMap.resaultAddress;

        }

        private void cratebtn_Click(object sender, RoutedEventArgs e)
        {
            NpgsqlConnection conn = new NpgsqlConnection();
            LogInWin.getConnection(conn, LogInWin.connstring);
            NpgsqlTransaction pgTran = conn.BeginTransaction();
            NpgsqlCommand command = conn.CreateCommand();
            command.Transaction = pgTran;
            try
            {
                command.CommandText =
              "CALL megainsert('"+ customernametb.Text + "', '" + customerlastnametb.Text + "', '" + castomerpatronymictb.Text + "', '" + customerphonenumbertb.Text + "', 'Санкт-Петербург "+ loadingaddressbtn.Text + "', 'Санкт-Петербург " + deliveryaddresstb.Text +"');";
                command.ExecuteNonQuery();
                pgTran.Commit();
                MessageBox.Show("Заявка успешно создана");
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                try
                {
                    pgTran.Rollback();
                }
                catch (Exception exRollback)
                {
                    MessageBox.Show(exRollback.Message);
                }

            }

            conn.Close();
        }
    }
}
