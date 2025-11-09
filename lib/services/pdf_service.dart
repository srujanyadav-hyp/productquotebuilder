import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/quote.dart';
import '../utils/helpers.dart';

/// Service for generating PDF documents from quotes
class PdfService {
  /// Format currency for PDF (without Unicode rupee symbol)
  static String _formatCurrencyForPdf(double value) {
    final formatted = FormatHelper.formatNumber(value);
    return 'Rs.$formatted';
  }

  /// Generate a printable PDF from a quote
  static Future<void> generateQuotePdf(Quote quote) async {
    final pdf = pw.Document();

    // Add page to PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(quote),
              pw.SizedBox(height: 24),

              // Client Info
              _buildClientInfo(quote),
              pw.SizedBox(height: 32),

              // Items Table
              _buildItemsTable(quote),
              pw.SizedBox(height: 24),

              // Totals
              _buildTotals(quote),
              pw.Spacer(),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Quote_${quote.id}.pdf',
    );
  }

  /// Build PDF header
  static pw.Widget _buildHeader(Quote quote) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'QUOTATION',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Quote #${quote.id}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Date: ${DateHelper.formatDate(quote.createdDate)}',
          style: const pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  /// Build client information section
  static pw.Widget _buildClientInfo(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'BILL TO:',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            quote.clientInfo.name,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            quote.clientInfo.address,
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Contact: ${quote.clientInfo.reference}',
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Build items table
  static pw.Widget _buildItemsTable(Quote quote) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ITEMS',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1),
            5: const pw.FlexColumnWidth(2),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue800),
              children: [
                _buildTableCell('Description', isHeader: true),
                _buildTableCell(
                  'Qty',
                  isHeader: true,
                  align: pw.TextAlign.center,
                ),
                _buildTableCell(
                  'Rate',
                  isHeader: true,
                  align: pw.TextAlign.right,
                ),
                _buildTableCell(
                  'Discount',
                  isHeader: true,
                  align: pw.TextAlign.right,
                ),
                _buildTableCell(
                  'Tax',
                  isHeader: true,
                  align: pw.TextAlign.center,
                ),
                _buildTableCell(
                  'Amount',
                  isHeader: true,
                  align: pw.TextAlign.right,
                ),
              ],
            ),
            // Data rows
            ...quote.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isEven = index % 2 == 0;

              return pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: isEven ? PdfColors.white : PdfColors.grey50,
                ),
                children: [
                  _buildTableCell(item.productName),
                  _buildTableCell(
                    item.quantity.toString(),
                    align: pw.TextAlign.center,
                  ),
                  _buildTableCell(
                    _formatCurrencyForPdf(item.rate),
                    align: pw.TextAlign.right,
                  ),
                  _buildTableCell(
                    _formatCurrencyForPdf(item.discount),
                    align: pw.TextAlign.right,
                  ),
                  _buildTableCell(
                    _formatCurrencyForPdf(item.taxPercent),
                    align: pw.TextAlign.center,
                  ),
                  _buildTableCell(
                    _formatCurrencyForPdf(item.itemTotal),
                    align: pw.TextAlign.right,
                    isBold: true,
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// Build a table cell
  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader || isBold
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
        ),
        textAlign: align,
      ),
    );
  }

  /// Build totals section
  static pw.Widget _buildTotals(Quote quote) {
    return pw.Container(
      width: 250,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        children: [
          _buildTotalRow('Subtotal (before tax)', quote.subtotalBeforeTax),
          pw.Divider(),
          _buildTotalRow('Total Tax', quote.totalTax),
          pw.Divider(thickness: 2),
          _buildTotalRow('GRAND TOTAL', quote.grandTotal, isGrandTotal: true),
        ],
      ),
    );
  }

  /// Build a total row
  static pw.Widget _buildTotalRow(
    String label,
    double amount, {
    bool isGrandTotal = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isGrandTotal ? 12 : 10,
              fontWeight: isGrandTotal
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              color: isGrandTotal ? PdfColors.blue800 : PdfColors.black,
            ),
          ),
          pw.Text(
            _formatCurrencyForPdf(amount),
            style: pw.TextStyle(
              fontSize: isGrandTotal ? 14 : 11,
              fontWeight: pw.FontWeight.bold,
              color: isGrandTotal ? PdfColors.blue800 : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Build footer
  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(
            fontSize: 11,
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey700,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated by Product Quote Builder',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}
