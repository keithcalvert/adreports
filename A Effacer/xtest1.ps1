[xml]$xaml = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Demo" WindowStartupLocation = "CenterScreen" 
        SizeToContent="WidthAndHeight"
        ShowInTaskbar = "True">

    <StackPanel Orientation="Vertical" Name="msiStackPanel">
        <TextBlock Margin="20,20,20,20" HorizontalAlignment="Center" FontSize="14" FontWeight="Bold">List of Stuff</TextBlock>
        <DataGrid Name="myGrid" ItemsSource="{Binding}">
            <DataGrid.Columns>
            </DataGrid.Columns>
        </DataGrid>
        <Button Margin="20,20,20,20">Completed All Tests</Button>
    </StackPanel>
</Window>
'@

# Set PowerShell variable for each named object in GUI
Function Set-WpfVariables
{
  param($children)
    ForEach ($child in $children.Children)
    {
        Set-WpfVariables -Children $child
        if (![String]::IsNullOrEmpty($child.Name))
        {
            Write-Host "Set variable $($child.Name)"
            Set-Variable -Name $child.Name -Value $child -Scope global
        }    
    }
}

# Build Window
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

$controls = [System.Windows.LogicalTreeHelper]::GetChildren($window)
Set-WpfVariables -Children $controls

$table = New-Object System.Data.DataTable
$table.Columns.Add("Name")
$table.Rows.Add("Row 1")
$table.Rows.Add("Row 2")
$table.Rows.Add("Row 3")


#$myGrid.DataContext = $table.DefaultView #This did not work for me. so...
$myGrid = $window.FindName("myGrid")
$myGrid.ItemsSource = $table.DefaultView


[System.Windows.RoutedEventHandler]$clickEvent = {
param ($sender,$e)
    Write-Host "Clicked row $($myGrid.SelectedItem.Row.Name)"
}

$buttonColumn = New-Object System.Windows.Controls.DataGridTemplateColumn
$buttonFactory = New-Object System.Windows.FrameworkElementFactory([System.Windows.Controls.Button])
$buttonFactory.SetValue([System.Windows.Controls.Button]::ContentProperty, "Launch")
$buttonFactory.AddHandler([System.Windows.Controls.Button]::ClickEvent,$clickEvent)
$dataTemplate = New-Object System.Windows.DataTemplate
$dataTemplate.VisualTree = $buttonFactory
$buttonColumn.CellTemplate = $dataTemplate
$myGrid.Columns.Add($buttonColumn)

$myGrid.DataContext = $table.DefaultView

$window.ShowDialog()