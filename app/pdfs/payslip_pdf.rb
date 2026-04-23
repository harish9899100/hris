class PayslipPdf
  def initialize(payslip)
    @payslip  = payslip
    @employee = payslip.employee
  end

  def render
    Prawn::Document.new(page_size: "A4", margin: [40, 50, 40, 50]) do |pdf|
      pdf.fill_color "3B4FE4"
      pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 80
      pdf.fill_color "FFFFFF"
      pdf.bounding_box([10, pdf.cursor - 10], width: pdf.bounds.width - 20) do
        pdf.text "PAYSLIP", size: 26, style: :bold
        pdf.move_down 4
        pdf.text "#{Date::MONTHNAMES[@payslip.month]} #{@payslip.year}", size: 12
      end
      pdf.move_down 20
      pdf.fill_color "000000"

      pdf.text "Employee Details", size: 13, style: :bold, color: "3B4FE4"
      pdf.stroke_horizontal_rule
      pdf.move_down 8

      details = [
        ["Name",        @employee.full_name],
        ["Employee ID", @employee.employee_id.to_s],
        ["Department",  @employee.department&.name || "—"],
        ["Position",    @employee.position&.title  || "—"],
        ["Pay Period",  "#{Date::MONTHNAMES[@payslip.month]} #{@payslip.year}"],
      ]

      details.each do |label, value|
        pdf.text "<b>#{label}:</b>  #{value}", inline_format: true, size: 10, leading: 4
      end

      pdf.move_down 20

      pdf.text "Salary Breakdown", size: 13, style: :bold, color: "3B4FE4"
      pdf.stroke_horizontal_rule
      pdf.move_down 8

      table_data = [
        ["Description", "Amount (Rs.)"],
        ["Gross Salary", format_money(@payslip.gross)],
        ["Deductions",   format_money(@payslip.deductions)],
        ["Net Salary",   format_money(@payslip.net)],
      ]

      pdf.table(table_data, width: pdf.bounds.width, cell_style: { size: 10, padding: [6, 8] }) do
        row(0).background_color = "3B4FE4"
        row(0).text_color       = "FFFFFF"
        row(0).font_style       = :bold
        columns(1).align        = :right
        row(3).font_style       = :bold
        self.header             = true
      end

      pdf.move_down 20

      pdf.stroke_horizontal_rule
      pdf.move_down 6
      pdf.text "This is a system-generated payslip and does not require a signature.",
               size: 8, color: "888888", align: :center
      pdf.text "Generated on #{Date.current.strftime('%B %-d, %Y')}",
               size: 8, color: "888888", align: :center
    end.render
  end

  private

  def format_money(amount)
    "Rs. #{format('%.2f', amount.to_f)}"
  end
end