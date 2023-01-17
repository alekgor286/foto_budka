package com.foto_budka.foto_budka;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    // Save the photo to a temporary location
    try {
      byte[] bytes = photo.getBytes();
      Path path = Paths.get("/tmp/photos/" + photo.getOriginalFilename());
      Files.write(path, bytes);
    } catch (IOException e) {
      e.printStackTrace();
      return new ResponseEntity<>("Failed to upload photo", HttpStatus.INTERNAL_SERVER_ERROR);
    }

    return new ResponseEntity<>("Successfully uploaded photo", HttpStatus.OK);
  }
}
