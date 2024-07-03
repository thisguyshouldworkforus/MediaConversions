#!/opt/projects/kid-shows/venv/bin/python3

import os
import subprocess
import re

def extract_metadata(file_path):
    command = ['ffmpeg', '-i', file_path]
    try:
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        return result.stderr  # Metadata output is typically in stderr for ffmpeg
    except subprocess.CalledProcessError as e:
        # ffmpeg returns non-zero exit status because no output file is specified, but we still get the metadata.
        return e.stderr

def parse_chapters(metadata):
    chapters = []
    chapter_pattern = re.compile(r'Chapter #0:(\d+): start ([\d.]+), end ([\d.]+)\n\s+Metadata:\n\s+title\s+: (.+)')
    for match in chapter_pattern.finditer(metadata):
        chapters.append({
            'index': int(match.group(1)),
            'start': float(match.group(2)),
            'end': float(match.group(3)),
            'title': match.group(4)
        })
    return chapters

def find_english_audio_track(metadata):
    audio_track_pattern = re.compile(r'Stream #0:(\d+)\(eng\): Audio')
    match = audio_track_pattern.search(metadata)
    if match:
        return match.group(1)
    return None

def reencode_scene(file_path, start, end, output_file, audio_track):
    command = [
        'ffmpeg', '-hwaccel', 'cuda', '-i', file_path, '-ss', str(start), '-to', str(end),
        '-map', '0:v:0', '-map', f'0:{audio_track}', '-c:v', 'hevc_nvenc', '-c:a', 'copy', output_file
    ]
    subprocess.run(command, check=True)

def process_file(root, file):
    file_root = root
    file_name = file
    file_path = os.path.join(root, file)
    temp_path = "/opt/projects/kid-shows/DEST"
    metadata = extract_metadata(file_path)
    chapters = parse_chapters(metadata)

    audio_track = find_english_audio_track(metadata)
    if not audio_track:
        print(f"No English audio track found in {file_name}")
        return False

    for chapter in chapters:
        if chapter['title'] == "intro_end":
            output_file = f"{temp_path}/{file_name}_Scene_1.mkv"
            reencode_scene(file_path, chapter['start'], chapter['end'], output_file, audio_track)
        if chapter['title'] == "Scene 1":
            output_file = f"{temp_path}/{file_name}_Scene_2.mkv"
            reencode_scene(file_path, chapter['start'], chapter['end'], output_file, audio_track)

def main(directory):
    # Traverse the directory tree
    for root, dirs, files in os.walk(directory):
        # Loop through the list of files
        for file in files:
            # Process only MKV files
            if file.endswith(".mkv"):
                # Process the file
                process_file(root, file)

if __name__ == "__main__":
    directory = "/opt/projects/kid-shows/SOURCE"
    main(directory)
