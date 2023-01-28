package com.foto_budka.foto_budka;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/photos")
public class PhotoController {

  @PostMapping("/upload")
  public ResponseEntity<String> uploadPhoto(@RequestParam("photo") MultipartFile photo) {
    try {
      String projectDir = System.getProperty("user.dir");
      Path tmpDir = Paths.get(projectDir, "tmp");
      if (!Files.exists(tmpDir)) {
        Files.createDirectory(tmpDir);
      }
      Path filePath = Paths.get(tmpDir.toString(), photo.getOriginalFilename());
      byte[] bytes = photo.getBytes();
      Files.write(filePath, bytes);
    } catch (IOException e) {
      e.printStackTrace();
      return new ResponseEntity<>("Failed to upload photo", HttpStatus.INTERNAL_SERVER_ERROR);
    }
    return new ResponseEntity<>("Successfully uploaded photo", HttpStatus.OK);
  }

  @GetMapping("/downloadPDF")
  public ResponseEntity<InputStreamResource> downloadPDF() {
    try {
      // create a new PDF document
      Document document = new Document();
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      PdfWriter.getInstance(document, out);
      document.open();
      PdfPTable table = new PdfPTable(4);
      table.setWidthPercentage(100);
      table.setSpacingAfter(0);
      table.setSpacingBefore(0);

      File folder = new File("tmp");
      File[] listOfFiles = folder.listFiles();
      for (int i = 0; i < listOfFiles.length; i++) {
        if (listOfFiles[i].isFile()) {
          Image img = Image.getInstance(listOfFiles[i].getAbsolutePath());
          //compress the image to fit the cell size
          img.scaleToFit(100f, 100f);
          PdfPCell cell1 = new PdfPCell(img);
          cell1.setBorder(Rectangle.NO_BORDER);
          table.addCell(cell1);

          // create banner image
          Image banner = Image.getInstance("banner.png");
          banner.scaleToFit(100f, 100f);
          PdfPCell cell2 = new PdfPCell(banner);
          cell2.setBorder(Rectangle.NO_BORDER);
          table.addCell(cell2);

          //create the same content as the first column
          PdfPCell cell3 = new PdfPCell(img);
          cell3.setBorder(Rectangle.NO_BORDER);
          table.addCell(cell3);

          //create another banner image
          PdfPCell cell4 = new PdfPCell(banner);
          cell4.setBorder(Rectangle.NO_BORDER);
          table.addCell(cell4);
        }
      }
      document.add(table);
      document.close();
      FileUtils.cleanDirectory(folder);

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_PDF);
      headers.add("Content-Disposition", "attachment; filename=photo_booth.pdf");
      headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
      ResponseEntity<InputStreamResource> response = new ResponseEntity<InputStreamResource>(
          new InputStreamResource(new ByteArrayInputStream(out.toByteArray())), headers, HttpStatus.OK);
      return response;
    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<InputStreamResource>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }



}
