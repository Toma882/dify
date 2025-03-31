"""Abstract interface for document loader implementations."""

from pathlib import Path
from typing import Optional
import io

from core.rag.extractor.extractor_base import BaseExtractor
from core.rag.extractor.helpers import detect_file_encodings
from core.rag.models.document import Document


class TextExtractor(BaseExtractor):
    """Load text files.


    Args:
        file_path: Path to the file to load.
    """

    def __init__(self, file_path: str, encoding: Optional[str] = None, autodetect_encoding: bool = False):
        """Initialize with file path."""
        self._file_path = file_path
        self._encoding = encoding
        self._autodetect_encoding = autodetect_encoding

    def extract(self) -> list[Document]:
        """Load from file path."""
        text = ""
        try:
            # 尝试读取文件内容
            if self._encoding:
                # 使用指定的编码读取
                with open(self._file_path, 'rb') as f:
                    content = f.read()
                    text = content.decode(self._encoding, errors='replace')
            else:
                # 使用默认编码读取
                text = Path(self._file_path).read_text()
        except UnicodeDecodeError as e:
            if self._autodetect_encoding:
                # 自动检测编码并尝试读取
                detected_encodings = detect_file_encodings(self._file_path)
                for encoding in detected_encodings:
                    try:
                        with open(self._file_path, 'rb') as f:
                            content = f.read()
                            text = content.decode(encoding.encoding, errors='replace')
                        break
                    except UnicodeDecodeError:
                        continue
            else:
                raise RuntimeError(f"Error loading {self._file_path}") from e
        except Exception as e:
            raise RuntimeError(f"Error loading {self._file_path}") from e

        # 确保文本是UTF-8格式（Python内部已经是Unicode，这一步实际上是处理任何特殊字符）
        text_utf8 = text.encode('utf-8', errors='replace').decode('utf-8')

        metadata = {"source": self._file_path}
        return [Document(page_content=text_utf8, metadata=metadata)]
