---
layout: default
title: 글쓰기
permalink: /write/
noindex: true
---

<section class="write-page">
  <header class="write-head">
    <div class="write-head-copy">
      <p class="eyebrow">STUDY NOTES</p>
      <h1>글쓰기</h1>
      <p>제목과 본문을 적고, 미리보기에서 확인한 뒤 글과 첨부 이미지를 저장합니다.</p>
    </div>
    <div class="write-actions">
      <div class="write-action-buttons">
        <button type="button" id="reset-post">새 글</button>
        <button type="button" id="download-post" class="primary">글 파일 저장</button>
      </div>
      <p class="status" id="status" role="status" aria-live="polite">초안은 이 브라우저에 자동 저장됩니다.</p>
    </div>
  </header>

  <div class="write-grid">
    <section class="editor-panel" aria-labelledby="editor-heading">
      <div class="panel-heading">
        <div><span class="panel-index">01 / WRITE</span><h2 id="editor-heading">글 정보</h2></div>
        <span class="panel-hint">작성한 글은 브라우저에 저장됩니다.</span>
      </div>

      <div class="write-fields">
        <label class="write-field write-field-title" for="post-title">
          <span>제목</span>
          <input id="post-title" type="text" maxlength="160" autocomplete="off" placeholder="글 제목">
        </label>
        <div class="write-field-row">
          <label class="write-field" for="post-date">
            <span>날짜</span>
            <input id="post-date" type="date">
          </label>
          <label class="write-field" for="post-tags">
            <span>태그 <small>쉼표로 구분</small></span>
            <input id="post-tags" type="text" maxlength="500" autocomplete="off" placeholder="Java, Spring">
          </label>
        </div>
        <div class="write-field">
          <label for="post-category"><span>분류</span></label>
          <div class="category-row">
            <select id="post-category">
              <option value="auto" selected>본문을 보고 자동으로 선택</option>
              <optgroup label="Java">
                <option value="section:java-core" data-section="java-core" data-parent="java" data-label="Java 기본">Java 기본</option>
                <option value="section:java-oop" data-section="java-oop" data-parent="java" data-label="객체지향 / SOLID">객체지향 / SOLID</option>
                <option value="section:java-pattern" data-section="java-pattern" data-parent="java" data-label="디자인 패턴">디자인 패턴</option>
                <option value="section:java-generics" data-section="java-generics" data-parent="java" data-label="Generic">Generic</option>
                <option value="section:java-functional" data-section="java-functional" data-parent="java" data-label="함수형 / Lambda / Stream">함수형 / Lambda / Stream</option>
                <option value="section:java-collections" data-section="java-collections" data-parent="java" data-label="컬렉션">컬렉션</option>
                <option value="section:java-jvm" data-section="java-jvm" data-parent="java" data-label="JVM">JVM</option>
                <option value="section:java-concurrency" data-section="java-concurrency" data-parent="java" data-label="동시성">동시성</option>
                <option value="section:java-io" data-section="java-io" data-parent="java" data-label="입출력 / NIO">입출력 / NIO</option>
              </optgroup>
              <optgroup label="Spring">
                <option value="section:spring-core" data-section="spring-core" data-parent="spring" data-label="Spring Core / DI / AOP">Spring Core / DI / AOP</option>
                <option value="section:spring-data" data-section="spring-data" data-parent="spring" data-label="JPA / MyBatis">JPA / MyBatis</option>
                <option value="section:spring-web" data-section="spring-web" data-parent="spring" data-label="MVC / WebFlux / REST API">MVC / WebFlux / REST API</option>
                <option value="section:spring-security" data-section="spring-security" data-parent="spring" data-label="Security / JWT / OAuth2">Security / JWT / OAuth2</option>
                <option value="section:spring-testing" data-section="spring-testing" data-parent="spring" data-label="테스트 / 품질 관리">테스트 / 품질 관리</option>
                <option value="section:spring-ai" data-section="spring-ai" data-parent="spring" data-label="Spring AI">Spring AI</option>
              </optgroup>
              <optgroup label="Database">
                <option value="section:database-oracle" data-section="database-oracle" data-parent="database" data-label="Oracle / SQL / PL-SQL">Oracle / SQL / PL-SQL</option>
                <option value="section:database-redis" data-section="database-redis" data-parent="database" data-label="Redis">Redis</option>
                <option value="section:database-storage" data-section="database-storage" data-parent="database" data-label="MySQL / Docker Volume">MySQL / Docker Volume</option>
              </optgroup>
              <optgroup label="Backend">
                <option value="section:backend-messaging" data-section="backend-messaging" data-parent="backend" data-label="실시간 / 메시징">실시간 / 메시징</option>
                <option value="section:backend-performance" data-section="backend-performance" data-parent="backend" data-label="성능 / 부하 테스트">성능 / 부하 테스트</option>
              </optgroup>
              <optgroup label="Frontend">
                <option value="section:frontend-html" data-section="frontend-html" data-parent="frontend" data-label="HTML / CSS / JavaScript">HTML / CSS / JavaScript</option>
                <option value="section:frontend-react" data-section="frontend-react" data-parent="frontend" data-label="React">React</option>
              </optgroup>
              <optgroup label="Infra">
                <option value="section:infra-linux" data-section="infra-linux" data-parent="infra" data-label="Linux">Linux</option>
                <option value="section:infra-aws" data-section="infra-aws" data-parent="infra" data-label="AWS / EC2">AWS / EC2</option>
                <option value="section:infra-docker" data-section="infra-docker" data-parent="infra" data-label="Docker">Docker</option>
                <option value="section:infra-cicd" data-section="infra-cicd" data-parent="infra" data-label="GitHub Actions / CI-CD">GitHub Actions / CI-CD</option>
              </optgroup>
              <optgroup label="ML">
                <option value="section:ml" data-section="ml" data-parent="ml" data-label="Machine Learning">Machine Learning</option>
              </optgroup>
              <optgroup label="기타"><option value="section:other" data-section="other" data-parent="other" data-label="기타">기타</option></optgroup>
              {% assign built_in_sections = 'java-core,java-oop,java-pattern,java-generics,java-functional,java-collections,java-jvm,java-concurrency,java-io,spring-core,spring-data,spring-web,spring-security,spring-testing,spring-ai,database-oracle,database-redis,database-storage,backend-messaging,backend-performance,frontend-html,frontend-react,infra-linux,infra-aws,infra-docker,infra-cicd,ml,other' | split: ',' %}
              {% assign saved_sections = site.posts | map: 'section' | compact | uniq | sort_natural %}
              {% assign custom_count = 0 %}
              {% for saved_section in saved_sections %}
                {% unless built_in_sections contains saved_section %}{% assign custom_count = custom_count | plus: 1 %}{% endunless %}
              {% endfor %}
              {% if custom_count > 0 %}<optgroup label="소분류">
              {% for saved_section in saved_sections %}
                {% unless built_in_sections contains saved_section %}
                  {% assign saved_post = site.posts | where: 'section', saved_section | first %}
                  {% assign saved_parent = saved_post.section_parent | default: 'custom' %}
                  {% assign saved_parent_label = saved_post.section_parent_label | default: '내 분류' %}
                  {% assign saved_label = saved_post.section_label | default: saved_section %}
                  <option value="section:{{ saved_section | escape }}" data-section="{{ saved_section | escape }}" data-parent="{{ saved_parent | escape }}" data-parent-label="{{ saved_parent_label | escape }}" data-label="{{ saved_label | escape }}" data-custom-section="true">{{ saved_parent_label | escape }} / {{ saved_label | escape }}</option>
                {% endunless %}
              {% endfor %}
              </optgroup>{% endif %}
              <option value="new">새 대분류 / 소분류 만들기</option>
            </select>
            <button type="button" id="add-category" class="secondary-button">소분류 추가</button>
          </div>
          <div class="custom-category" id="custom-category-fields" hidden>
            <div class="custom-category-grid">
              <label class="write-field" for="custom-category-parent">
                <span>대분류</span>
                <select id="custom-category-parent">
                  <option value="new-parent" data-label="">새 대분류 만들기</option>
                  <optgroup label="기본 대분류">
                    <option value="java" data-label="Java">Java</option>
                    <option value="spring" data-label="Spring">Spring</option>
                    <option value="database" data-label="Database">Database</option>
                    <option value="backend" data-label="Backend">Backend</option>
                    <option value="frontend" data-label="Frontend">Frontend</option>
                    <option value="infra" data-label="Infra">Infra</option>
                    <option value="ml" data-label="ML">ML</option>
                    <option value="other" data-label="기타">기타</option>
                  </optgroup>
                  {% assign saved_parent_keys = site.posts | map: 'section_parent' | compact | uniq | sort_natural %}
                  <optgroup label="내 대분류">
                    <option value="custom" data-label="내 분류">내 분류</option>
                    {% for saved_parent_key in saved_parent_keys %}
                      {% if saved_parent_key contains 'custom-' %}
                        {% assign saved_parent_post = site.posts | where: 'section_parent', saved_parent_key | first %}
                        <option value="{{ saved_parent_key | escape }}" data-label="{{ saved_parent_post.section_parent_label | default: saved_parent_key | escape }}">{{ saved_parent_post.section_parent_label | default: saved_parent_key | escape }}</option>
                      {% endif %}
                    {% endfor %}
                  </optgroup>
                </select>
              </label>
              <label class="write-field" id="custom-parent-name-field" for="custom-category-parent-name" hidden>
                <span>새 대분류 이름</span>
                <input id="custom-category-parent-name" type="text" maxlength="60" autocomplete="off" placeholder="예: 네트워크">
              </label>
              <label class="write-field" for="custom-category-name">
                <span>소분류</span>
                <input id="custom-category-name" type="text" maxlength="60" autocomplete="off" aria-describedby="custom-category-help" placeholder="예: HTTP 기초">
              </label>
            </div>
            <p id="custom-category-help">대분류를 고르거나 새로 만든 뒤 소분류 이름을 입력하세요. 글을 게시하면 분류 목록에 반영됩니다.</p>
          </div>
        </div>
        <div class="write-meta" aria-live="polite">
          <span id="meta-summary">분류는 본문 내용을 기준으로 자동 선택됩니다.</span>
        </div>
      </div>

      <div class="body-editor-heading"><h3>본문</h3><span>MARKDOWN</span></div>
      <div class="editor-toolbar" role="toolbar" aria-label="Markdown 서식">
        <button type="button" data-action="bold" aria-label="굵게" title="굵게"><strong>B</strong></button>
        <button type="button" data-action="heading" aria-label="소제목" title="소제목">H2</button>
        <button type="button" data-action="code" aria-label="코드 블록" title="코드 블록">{ }</button>
        <button type="button" data-action="quote" aria-label="인용문" title="인용문">❝</button>
        <button type="button" data-action="list" aria-label="목록" title="목록">• 목록</button>
        <button type="button" data-action="table" aria-label="표" title="표">표</button>
        <button type="button" data-action="link" aria-label="링크" title="링크">링크</button>
      </div>
      <div class="image-attachment-panel">
        <div class="image-attachment-top">
          <div>
            <strong>본문에 이미지 추가</strong>
            <p>이미지당 5MB 이하 · PNG, JPG, GIF, WebP, AVIF · 최대 10장</p>
          </div>
          <input id="post-images" type="file" accept="image/png,image/jpeg,image/gif,image/webp,image/avif" multiple hidden>
          <button type="button" id="add-images" class="secondary-button">이미지 첨부</button>
        </div>
        <div class="image-attachments" id="image-attachments" aria-live="polite" hidden></div>
        <p class="image-attachment-feedback" id="image-attachment-feedback" role="status" aria-live="polite" hidden></p>
      </div>
      <label class="sr-only" for="post-body">Markdown 본문</label>
      <textarea id="post-body" spellcheck="false" placeholder="Markdown 본문을 적거나 글 전체를 붙여넣으세요.

글 전체를 붙여넣으면 Front Matter의 제목, 날짜, 태그, 분류를 읽습니다.

## 다룰 내용
어떤 문제나 개념을 정리하는지 적습니다.

## 동작과 예제
필요한 코드, 표, 명령어를 넣습니다.

## 직접 확인한 결과
실행 결과나 참고한 문서를 적습니다."></textarea>
    </section>

    <section class="preview-panel" aria-labelledby="preview-heading">
      <div class="panel-heading preview-heading">
        <div><span class="panel-index">02 / PREVIEW</span><h2 id="preview-heading">미리보기</h2></div>
        <span class="preview-state" id="preview-state">작성 중</span>
      </div>
      <article class="post-content" id="post-preview">
        <h1 class="preview-title" id="preview-title" hidden></h1>
        <div id="preview-body"><p class="preview-empty">본문을 입력하면 여기에서 확인할 수 있습니다.</p></div>
      </article>
    </section>
  </div>

  <div class="write-notes">
    <p class="write-note"><strong>분류</strong> · 기본 대분류 아래에 새 소분류를 추가하거나, 새 대분류와 소분류를 함께 만들 수 있습니다. 글을 <code>_posts</code>에 추가하면 블로그 목록에 반영됩니다.</p>
    <p class="write-note"><strong>저장</strong> · 임시 초안과 첨부 이미지는 이 브라우저에 보관됩니다. 이미지가 있으면 글과 이미지 경로를 담은 ZIP을 저장해 저장소 루트에 풀어 넣습니다.</p>
    <p class="write-note"><strong>글 구성</strong> · 질문, 핵심 내용, 예제, 직접 확인한 결과 순으로 쓰면 정리하기 쉽습니다. 글에 맞지 않는 부분은 빼도 됩니다.</p>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dompurify@3.2.6/dist/purify.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js"></script>
<script>
(() => {
  const body = document.getElementById('post-body');
  const titleInput = document.getElementById('post-title');
  const dateInput = document.getElementById('post-date');
  const tagsInput = document.getElementById('post-tags');
  const categorySelect = document.getElementById('post-category');
  const customFields = document.getElementById('custom-category-fields');
  const customParentSelect = document.getElementById('custom-category-parent');
  const customParentNameField = document.getElementById('custom-parent-name-field');
  const customParentNameInput = document.getElementById('custom-category-parent-name');
  const customCategoryInput = document.getElementById('custom-category-name');
  const previewTitle = document.getElementById('preview-title');
  const previewBody = document.getElementById('preview-body');
  const status = document.getElementById('status');
  const metaSummary = document.getElementById('meta-summary');
  const previewState = document.getElementById('preview-state');
  const imageInput = document.getElementById('post-images');
  const addImagesButton = document.getElementById('add-images');
  const imageAttachmentsPanel = document.getElementById('image-attachments');
  const imageAttachmentFeedback = document.getElementById('image-attachment-feedback');
  const draftKey = 'zuzusnasna-study-draft';
  const imageDbName = 'zuzusnasna-study-images';
  const maxImageSize = 5 * 1024 * 1024;
  const maxImageCount = 10;
  const allowedImageExtensions = new Set(['png', 'jpg', 'jpeg', 'gif', 'webp', 'avif']);
  let draftId = window.crypto?.randomUUID?.() || 'draft-' + Date.now().toString(36) + Math.random().toString(36).slice(2, 10);
  let attachedImages = [];
  let imageInsertPosition = 0;
  let attachmentsRestoring = false;
  let imageDbPromise;
  const tick = String.fromCharCode(96);
  const fencePattern = new RegExp('^ {0,3}(' + tick + '{3,}|~{3,})');

  const createId = () => window.crypto?.randomUUID?.() || Date.now().toString(36) + '-' + Math.random().toString(36).slice(2, 10);
  const isSafeImageFilename = value => typeof value === 'string' && /^image-[a-zA-Z0-9-]+\.(png|jpe?g|gif|webp|avif)$/.test(value);
  const openImageDb = () => {
    if (!window.indexedDB) return Promise.reject(new Error('이 브라우저에서는 이미지 초안을 저장할 수 없습니다.'));
    if (!imageDbPromise) {
      imageDbPromise = new Promise((resolve, reject) => {
        const request = window.indexedDB.open(imageDbName, 1);
        request.onupgradeneeded = () => {
          if (!request.result.objectStoreNames.contains('images')) request.result.createObjectStore('images', {keyPath: 'id'});
        };
        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error || new Error('이미지 저장소를 열지 못했습니다.'));
      });
    }
    return imageDbPromise;
  };
  const saveImageBlob = async record => {
    const db = await openImageDb();
    return new Promise((resolve, reject) => {
      const transaction = db.transaction('images', 'readwrite');
      transaction.objectStore('images').put(record);
      transaction.oncomplete = resolve;
      transaction.onerror = () => reject(transaction.error || new Error('이미지를 브라우저에 저장하지 못했습니다.'));
      transaction.onabort = () => reject(transaction.error || new Error('이미지 저장이 취소되었습니다.'));
    });
  };
  const readImageBlob = async id => {
    const db = await openImageDb();
    return new Promise((resolve, reject) => {
      const request = db.transaction('images', 'readonly').objectStore('images').get(id);
      request.onsuccess = () => resolve(request.result?.blob || null);
      request.onerror = () => reject(request.error || new Error('저장한 이미지를 불러오지 못했습니다.'));
    });
  };
  const deleteImageBlob = async id => {
    try {
      const db = await openImageDb();
      await new Promise((resolve, reject) => {
        const transaction = db.transaction('images', 'readwrite');
        transaction.objectStore('images').delete(id);
        transaction.oncomplete = resolve;
        transaction.onerror = () => reject(transaction.error);
        transaction.onabort = () => reject(transaction.error);
      });
    } catch (_) {}
  };

  const today = () => {
    const date = new Date();
    return new Date(date.getTime() - date.getTimezoneOffset() * 60000).toISOString().slice(0, 10);
  };

  const parseScalar = raw => {
    const value = String(raw || '').trim();
    if (value.length >= 2 && value[0] === '"' && value[value.length - 1] === '"') {
      try { return JSON.parse(value); } catch (_) { return value.slice(1, -1); }
    }
    if (value.length >= 2 && value[0] === "'" && value[value.length - 1] === "'") {
      return value.slice(1, -1).replace(/''/g, "'");
    }
    return value;
  };

  const splitYamlList = raw => {
    let value = String(raw || '').trim();
    if (value.startsWith('[') && value.endsWith(']')) value = value.slice(1, -1);
    const parts = [];
    let current = '';
    let quote = '';
    let escaped = false;
    for (let i = 0; i < value.length; i++) {
      const char = value[i];
      if (escaped) { current += char; escaped = false; continue; }
      if (quote === '"' && char === '\\') { current += char; escaped = true; continue; }
      if (quote) {
        if (char === quote) {
          if (quote === "'" && value[i + 1] === "'") { current += "''"; i++; continue; }
          quote = '';
        }
        current += char;
        continue;
      }
      if (char === '"' || char === "'") { quote = char; current += char; continue; }
      if (char === ',') { parts.push(parseScalar(current)); current = ''; continue; }
      current += char;
    }
    if (current.trim()) parts.push(parseScalar(current));
    return parts.map(item => String(item).trim()).filter(Boolean);
  };

  const parseYaml = raw => {
    const value = String(raw || '').trim();
    if (value.startsWith('[') && value.endsWith(']')) return splitYamlList(value);
    return parseScalar(value);
  };

  const readFrontMatter = source => {
    const cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    const match = cleaned.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
    if (!match) return null;
    const data = {};
    const lines = match[1].split(/\r?\n/);
    for (let i = 0; i < lines.length; i++) {
      const item = lines[i].match(/^([A-Za-z0-9_-]+):(?:\s*(.*))?$/);
      if (!item) continue;
      const key = item[1];
      const value = item[2] || '';
      if (!value) {
        const list = [];
        let next = i + 1;
        while (next < lines.length) {
          const listItem = lines[next].match(/^\s+-\s+(.*)$/);
          if (!listItem) break;
          list.push(parseScalar(listItem[1]));
          next++;
        }
        data[key] = list.length ? list : '';
        i = next - 1;
      } else {
        data[key] = parseYaml(value);
      }
    }
    return {data, body: cleaned.slice(match[0].length).trimStart()};
  };

  const stripFrontMatter = source => {
    let cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    let previous = null;
    while (cleaned !== previous) {
      previous = cleaned;
      const match = cleaned.match(/^---\r?\n[\s\S]*?\r?\n---(?:\r?\n|$)/);
      if (!match) break;
      cleaned = cleaned.slice(match[0].length).trimStart();
    }
    return cleaned;
  };

  const normalizeDate = value => {
    const raw = String(value || '').trim();
    if (!raw) return '';
    const match = raw.match(/\b(\d{4})-(\d{2})-(\d{2})\b/);
    if (!match) return '';
    const year = Number(match[1]), month = Number(match[2]), day = Number(match[3]);
    const date = new Date(Date.UTC(year, month - 1, day));
    if (date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day) return '';
    return match[1] + '-' + match[2] + '-' + match[3];
  };

  const normalizeTags = value => {
    if (Array.isArray(value)) return value.map(tag => String(tag).trim()).filter(Boolean);
    const text = String(value || '').trim();
    return text ? splitYamlList(text) : [];
  };

  const rules = [
    ['spring-ai', 'Spring', /\b(spring ai|spring-ai|chatclient|prompttemplate|ollama|openai api|embedding|vector store|retrieval augmented generation|model context protocol|mcp|rag|chat memory|chatmemory|chatmemoryrepository|messagechatmemoryadvisor)\b|생성형.?ai|벡터.?스토어|대화 기억/i],
    ['java-jvm', 'Java', /\b(jvm|jit|gc|garbage collection|heap|metaspace|class loading|classloader)\b|가비지 컬렉션|클래스 로딩/i],
    ['java-collections', 'Java', /\b(collection|arraylist|linkedlist|hashmap|hashset|treeset|deque|iterator|comparator)\b|컬렉션/i],
    ['java-concurrency', 'Java', /\b(concurrency|synchronized|reentrantlock|executorservice|completablefuture|volatile|atomic|threadlocal|deadlock|thread|lock)\b|동시성|스레드/i],
    ['java-io', 'Java', /\b(filechannel|nio|inputstream|outputstream|bufferedreader|bufferedinputstream|serialization)\b|입출력|직렬화/i],
    ['java-pattern', 'Java', /\b(design pattern|singleton|strategy|factory|observer|command|decorator|adapter|facade|builder|prototype)\b|디자인.?패턴/i],
    ['java-oop', 'Java', /\b(solid|oop|inheritance|composition|coupling|cohesion|abstract class)\b|객체지향|상속|다형성|캡슐화|추상화/i],
    ['java-functional', 'Java', /\b(lambda|stream|functional programming)\b|람다|함수형/i],
    ['java-generics', 'Java', /\bgeneric\b|제네릭/i],
    ['spring-data', 'Spring', /\b(jpa|mybatis|hibernate|entitymanager|orm|fetch join)\b/i],
    ['spring-security', 'Spring', /\b(spring security|jwt|oauth2|oauth|csrf|cors|filter chain)\b/i],
    ['spring-testing', 'Spring', /\b(junit|mockito|mockmvc|integration test|test slice)\b|테스트/i],
    ['spring-web', 'Spring', /\b(rest api|spring mvc|webflux|reactive|controller|http status|pagination|idempotency)\b|웹.?mvc/i],
    ['spring-core', 'Spring', /\b(spring|di|ioc|aop|bean|applicationcontext|transaction|proxy)\b/i],
    ['database-storage', 'Database', /\bdocker volume\b|\bbind mount\b|\bnamed volume\b|도커.?볼륨/i],
    ['database-redis', 'Database', /\b(redis|sorted set|zset|pub.?sub)\b/i],
    ['database-oracle', 'Database', /\b(oracle|sql|pl.?sql|cursor|procedure|trigger|job|query|index|execution plan|mysql|database)\b|데이터베이스|쿼리|테이블/i],
    ['backend-messaging', 'Backend', /\b(websocket|stomp|kafka|rabbitmq|message broker|pub.?sub|outbox)\b|실시간.?메시징/i],
    ['backend-performance', 'Backend', /\b(k6|load test|performance|throughput|latency|p95|benchmark)\b|성능|부하 테스트/i],
    ['frontend-react', 'Frontend', /\b(react|vite|jsx|react router)\b/i],
    ['frontend-html', 'Frontend', /\b(html|css|javascript|js|dom)\b|프론트엔드/i],
    ['infra-cicd', 'Infra', /\b(github actions|ci\/cd|cicd|continuous integration|deployment pipeline)\b|배포 자동화/i],
    ['infra-docker', 'Infra', /\b(docker|container|docker compose)\b/i],
    ['infra-aws', 'Infra', /\b(aws|ec2|amazon web services)\b/i],
    ['infra-linux', 'Infra', /\b(linux|ubuntu|shell|bash)\b/i],
    ['ml', 'ML', /\b(machine learning|knn|logistic regression|decision tree|random forest|svc|scikit.?learn|classification)\b|머신러닝|분류 모델/i]
  ];

  const classify = text => {
    for (const [section, parent] of rules) {
      if (!parent.test(text)) continue;
      const option = [...categorySelect.options].find(item => item.dataset.section === section);
      return {section, parent: parent.toLowerCase(), label: option?.dataset.label || option?.textContent.trim() || section};
    }
    return {section: 'other', parent: 'other', label: '기타'};
  };

  const normalizeHeading = value => String(value || '').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]/gu, '');
  const fenceOpening = line => line.match(fencePattern);
  const isFenceClosing = (line, char, length) => new RegExp('^ {0,3}' + char + '{' + length + ',}[ \\t]*$').test(line);

  const autoTitle = source => {
    let fenceChar = '', fenceLength = 0;
    for (const line of String(source || '').replace(/\r\n/g, '\n').split('\n')) {
      const opening = fenceOpening(line);
      if (fenceChar) {
        if (opening && opening[1][0] === fenceChar && isFenceClosing(line, fenceChar, fenceLength)) {
          fenceChar = '';
          fenceLength = 0;
        }
        continue;
      }
      if (opening) {
        fenceChar = opening[1][0];
        fenceLength = opening[1].length;
        continue;
      }
      const heading = line.match(/^ {0,3}#(?!#)\s+(.+?)\s*#*\s*$/);
      if (heading) return heading[1].trim();
    }
    return '';
  };

  const normalizeArticle = (source, title) => {
    const output = [];
    let fenceChar = '', fenceLength = 0, firstContent = false;
    const lines = String(source || '').replace(/\r\n/g, '\n').split('\n');
    for (const line of lines) {
      const opening = fenceOpening(line);
      if (fenceChar) {
        if (opening && opening[1][0] === fenceChar && isFenceClosing(line, fenceChar, fenceLength)) {
          fenceChar = '';
          fenceLength = 0;
        }
        output.push(line);
        continue;
      }
      if (opening) {
        if (!firstContent && line.trim()) firstContent = true;
        fenceChar = opening[1][0];
        fenceLength = opening[1].length;
        output.push(line);
        continue;
      }
      if (!firstContent && line.trim()) {
        firstContent = true;
        const heading = line.match(/^ {0,3}#(?!#)\s+(.+?)\s*#*\s*$/);
        if (title && heading && normalizeHeading(heading[1]) === normalizeHeading(title)) continue;
      }
      const heading = line.match(/^( {0,3})#\s+(.+)$/);
      if (heading) {
        output.push(heading[1] + '## ' + heading[2]);
      } else {
        output.push(line);
      }
    }
    return output.join('\n').trim();
  };

  const render = source => {
    if (!window.marked || !window.DOMPurify) {
      return '<p class="preview-empty">미리보기 모듈을 불러오지 못했습니다. 네트워크 연결을 확인해 주세요.</p>';
    }
    try {
      const html = window.marked.parse(String(source || ''), {gfm: true, breaks: false});
      return window.DOMPurify.sanitize(html, {USE_PROFILES: {html: true}, ADD_ATTR: ['target', 'rel']});
    } catch (_) {
      return '<p class="preview-empty">미리보기를 만들지 못했습니다. 본문을 확인해 주세요.</p>';
    }
  };

  const formatImageSize = bytes => bytes < 1024 * 1024
    ? Math.max(1, Math.round(bytes / 1024)) + ' KB'
    : (bytes / (1024 * 1024)).toFixed(1) + ' MB';

  const renderAttachments = () => {
    imageAttachmentsPanel.replaceChildren();
    imageAttachmentsPanel.hidden = attachedImages.length === 0;
    attachedImages.forEach(image => {
      const card = document.createElement('div');
      card.className = 'image-attachment';
      if (image.previewUrl) {
        const preview = document.createElement('img');
        preview.src = image.previewUrl;
        preview.alt = '';
        preview.loading = 'lazy';
        card.append(preview);
      } else {
        const missing = document.createElement('span');
        missing.className = 'image-attachment-missing';
        missing.textContent = '이미지 복구 필요';
        card.append(missing);
      }
      const details = document.createElement('div');
      details.className = 'image-attachment-details';
      const name = document.createElement('strong');
      name.textContent = image.name;
      const size = document.createElement('small');
      size.textContent = formatImageSize(image.size);
      details.append(name, size);
      const remove = document.createElement('button');
      remove.type = 'button';
      remove.className = 'image-attachment-remove';
      remove.textContent = '삭제';
      remove.setAttribute('aria-label', image.name + ' 이미지 삭제');
      remove.addEventListener('click', () => {
        const pattern = new RegExp('!?\\[[^\\]]*\\]\\(' + image.path + '\\)', 'g');
        body.value = body.value.replace(pattern, '');
        attachedImages = attachedImages.filter(item => item.id !== image.id);
        if (image.previewUrl) URL.revokeObjectURL(image.previewUrl);
        void deleteImageBlob(image.id);
        renderAttachments();
        body.dispatchEvent(new Event('input', {bubbles: true}));
      });
      card.append(details, remove);
      imageAttachmentsPanel.append(card);
    });
  };

  const updatePreviewImages = () => {
    previewBody.querySelectorAll('img').forEach(preview => {
      const source = preview.getAttribute('src');
      const image = attachedImages.find(item => item.path === source);
      if (image?.previewUrl) preview.src = image.previewUrl;
    });
  };

  const yamlQuote = value => JSON.stringify(String(value || '').replace(/[\u0000-\u001F\u007F]/g, ' ').trim());
  const slugify = value => String(value || '').normalize('NFKC').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]+/gu, '-').replace(/^-|-$/g, '');

  const syncCustomParentFields = () => {
    customParentNameField.hidden = customParentSelect.value !== 'new-parent';
  };

  const selectedCategory = () => {
    const value = categorySelect.value;
    if (value === 'auto') {
      const classified = classify([titleInput.value, tagsInput.value, body.value].join(' '));
      const parentOption = [...customParentSelect.options].find(option => option.value === classified.parent);
      return {...classified, parentKey: classified.parent, parentLabel: parentOption?.dataset.label || classified.parent};
    }
    if (value === 'new') {
      const parentValue = customParentSelect.value;
      const parentOption = customParentSelect.selectedOptions[0];
      const parentLabel = String(parentValue === 'new-parent' ? customParentNameInput.value : parentOption?.dataset.label || parentOption?.textContent || '').trim();
      const parentSlug = slugify(parentLabel);
      if (!parentLabel) return {error: '대분류 이름을 입력해 주세요.', errorField: 'parent'};
      if (!parentSlug) return {error: '대분류 이름에 글자나 숫자를 넣어 주세요.', errorField: 'parent'};

      const label = customCategoryInput.value.trim();
      const childSlug = slugify(label);
      if (!label) return {error: '소분류 이름을 입력해 주세요.', errorField: 'child'};
      if (!childSlug) return {error: '소분류 이름에 글자나 숫자를 넣어 주세요.', errorField: 'child'};

      const existingParent = parentValue === 'new-parent'
        ? [...customParentSelect.options].find(option => option.dataset.label?.toLocaleLowerCase('ko-KR') === parentLabel.toLocaleLowerCase('ko-KR'))
        : parentOption;
      const parentKey = existingParent?.value && existingParent.value !== 'new-parent' ? existingParent.value : 'custom-' + parentSlug;
      return {section: 'custom-' + parentSlug + '--' + childSlug, parent: parentLabel, parentKey, parentLabel, label, isCustom: true};
    }
    const option = categorySelect.selectedOptions[0];
    if (!option) return {error: '분류를 다시 선택해 주세요.', errorField: 'category'};
    const parentKey = option.dataset.parent || 'custom';
    const parentOption = [...customParentSelect.options].find(item => item.value === parentKey);
    const parentLabel = option.dataset.parentLabel || parentOption?.dataset.label || (parentKey === 'custom' ? '내 분류' : parentKey);
    return {
      section: option.dataset.section || value.replace(/^section:/, ''),
      parent: parentLabel,
      parentKey,
      parentLabel,
      label: option.dataset.label || option.textContent.trim(),
      isCustom: option.dataset.customSection === 'true' || (option.dataset.section || '').startsWith('custom-')
    };
  };

  const safeReadDraft = () => {
    try { return localStorage.getItem(draftKey); } catch (_) { return null; }
  };
  const safeWriteDraft = () => {
    try {
      const category = selectedCategory();
      localStorage.setItem(draftKey, JSON.stringify({
        version: 4,
        draftId,
        title: titleInput.value,
        date: dateInput.value,
        tags: tagsInput.value,
        category: categorySelect.value,
        categoryData: categorySelect.value.startsWith('section:') && !category.error ? {
          section: category.section,
          label: category.label,
          parent: category.parentKey,
          parentLabel: category.parentLabel
        } : null,
        customCategory: customCategoryInput.value,
        customParent: customParentSelect.value,
        customParentLabel: category.parentLabel || customParentSelect.selectedOptions[0]?.dataset.label || customParentNameInput.value,
        customParentName: customParentNameInput.value,
        body: body.value,
        attachments: attachedImages.map(({id, name, filename, path, type, size}) => ({id, name, filename, path, type, size}))
      }));
      return true;
    } catch (_) { return false; }
  };
  const safeClearDraft = () => {
    try { localStorage.removeItem(draftKey); return true; } catch (_) { return false; }
  };

  const update = save => {
    const title = titleInput.value.trim() || autoTitle(body.value);
    const date = normalizeDate(dateInput.value);
    const tags = normalizeTags(tagsInput.value);
    const category = selectedCategory();
    previewTitle.textContent = title;
    previewTitle.hidden = !title;
    previewBody.innerHTML = body.value.trim()
      ? render(normalizeArticle(body.value, title))
      : '<p class="preview-empty">본문을 입력하면 여기에서 확인할 수 있습니다.</p>';
    updatePreviewImages();
    const categoryLabel = category.error ? '분류 이름 입력 필요' : (category.isCustom && category.parentLabel ? category.parentLabel + ' / ' + category.label : category.label || category.section);
    const dateLabel = date || '날짜 확인 필요';
    metaSummary.textContent = (title || '제목을 입력해 주세요') + ' · ' + dateLabel + ' · ' + (tags.length ? tags.join(', ') : '태그 없음') + ' · ' + categoryLabel;
    previewState.textContent = body.value.trim() ? '미리보기' : '본문 입력 대기';
    if (save) {
      status.textContent = '저장 중…';
      window.clearTimeout(update.saveTimer);
      update.saveTimer = window.setTimeout(() => {
        status.textContent = safeWriteDraft()
          ? '자동 저장됨 · ' + new Intl.DateTimeFormat('ko-KR', {hour: '2-digit', minute: '2-digit'}).format(new Date())
          : '브라우저 저장을 사용할 수 없습니다. 파일로 저장해 주세요.';
        status.className = 'status' + (status.textContent.startsWith('자동 저장됨') ? ' ok' : ' error');
      }, 250);
    }
  };

  const ensureCustomParentOption = (parentKey, label) => {
    if (!parentKey || [...customParentSelect.options].some(option => option.value === parentKey)) return;
    const group = customParentSelect.querySelector('optgroup[label="내 대분류"]');
    if (!group) return;
    const option = document.createElement('option');
    option.value = parentKey;
    option.dataset.label = label || parentKey;
    option.textContent = option.dataset.label;
    group.append(option);
  };

  const setCategoryFromFrontMatter = (section, label, parent, parentLabel) => {
    const options = [...categorySelect.options];
    const match = options.find(option => option.dataset.section === String(section || ''));
    const savedParent = String(parent || match?.dataset.parent || 'custom');
    const parentOption = [...customParentSelect.options].find(option => option.value === savedParent);
    const savedParentLabel = String(parentLabel || match?.dataset.parentLabel || parentOption?.dataset.label || (savedParent === 'custom' ? '내 분류' : savedParent));
    ensureCustomParentOption(savedParent, savedParentLabel);
    if (match) {
      categorySelect.value = match.value;
      customFields.hidden = true;
      customCategoryInput.value = '';
    } else if (section) {
      const option = document.createElement('option');
      option.value = 'section:' + section;
      option.dataset.section = section;
      option.dataset.parent = savedParent;
      option.dataset.parentLabel = savedParentLabel;
      option.dataset.label = label || section.replace(/^custom-/, '');
      option.dataset.customSection = 'true';
      option.textContent = savedParentLabel + ' / ' + option.dataset.label;
      categorySelect.insertBefore(option, categorySelect.querySelector('option[value="new"]'));
      categorySelect.value = option.value;
      customFields.hidden = true;
      customCategoryInput.value = '';
    } else {
      categorySelect.value = 'auto';
      customFields.hidden = true;
      customCategoryInput.value = '';
    }
    customParentSelect.value = savedParent;
    customParentNameInput.value = savedParent.startsWith('custom-') ? savedParentLabel : '';
    syncCustomParentFields();
  };

  const importFrontMatter = parsed => {
    const data = parsed.data || {};
    titleInput.value = String(data.title || autoTitle(parsed.body) || '');
    dateInput.value = data.date ? normalizeDate(data.date) : today();
    tagsInput.value = normalizeTags(data.tags).join(', ');
    setCategoryFromFrontMatter(data.section, data.section_label, data.section_parent, data.section_parent_label);
    body.value = parsed.body;
  };

  let updateTimer = 0;
  const scheduleUpdate = () => {
    window.clearTimeout(updateTimer);
    status.textContent = '수정 내용 저장 중…';
    status.className = 'status';
    updateTimer = window.setTimeout(() => update(true), 180);
  };

  const applyToolbar = action => {
    const start = body.selectionStart, end = body.selectionEnd;
    const selected = body.value.slice(start, end);
    const wrappers = {
      bold: ['**', '**'], heading: ['## ', ''], code: ['~~~\n', '\n~~~'], quote: ['> ', ''], list: ['- ', ''], link: ['[', '](https://)']
    };
    if (action === 'table') {
      const table = '| 항목 | 설명 |\n| --- | --- |\n| 항목 1 | 설명 입력 |\n| 항목 2 | 설명 입력 |';
      body.setRangeText(table, start, end, 'end');
    } else {
      const pair = wrappers[action];
      if (!pair) return;
      body.setRangeText(pair[0] + (selected || '내용') + pair[1], start, end, 'end');
    }
    body.focus();
    scheduleUpdate();
  };

  document.querySelectorAll('.editor-toolbar button').forEach(button => {
    button.addEventListener('click', () => applyToolbar(button.dataset.action));
  });

  const addImageFiles = async files => {
    const added = [];
    const errors = [];
    for (const file of files) {
      const extension = file.name.includes('.') ? file.name.split('.').pop().toLowerCase() : '';
      if (!allowedImageExtensions.has(extension) || (file.type && !file.type.startsWith('image/'))) {
        errors.push(file.name + ': 지원하는 이미지 형식이 아닙니다.');
        continue;
      }
      if (!file.size || file.size > maxImageSize) {
        errors.push(file.name + ': 이미지 크기는 5MB 이하여야 합니다.');
        continue;
      }
      if (attachedImages.length >= maxImageCount) {
        errors.push('이미지는 글 하나에 최대 10장까지 첨부할 수 있습니다.');
        break;
      }
      const id = createId();
      const filename = 'image-' + id.replace(/[^a-zA-Z0-9-]/g, '').slice(0, 24) + '.' + extension;
      const path = '/assets/images/posts/' + draftId + '/' + filename;
      try {
        await saveImageBlob({id, blob: file});
        const attachment = {
          id,
          name: file.name,
          filename,
          path,
          type: file.type || 'image/' + extension,
          size: file.size,
          blob: file,
          previewUrl: URL.createObjectURL(file)
        };
        attachedImages.push(attachment);
        added.push(attachment);
      } catch (error) {
        errors.push(file.name + ': ' + (error.message || '브라우저에 저장하지 못했습니다.'));
      }
    }

    if (added.length) {
      const markdown = added.map(image => {
        const alt = image.name.replace(/\.[^.]+$/, '').replace(/\\/g, '\\\\').replace(/\]/g, '\\]');
        return '![' + alt + '](' + image.path + ')';
      }).join('\n\n');
      const start = Math.min(imageInsertPosition, body.value.length);
      const before = body.value.slice(0, start);
      const after = body.value.slice(start);
      const prefix = before ? (before.endsWith('\n\n') ? '' : before.endsWith('\n') ? '\n' : '\n\n') : '';
      const suffix = after ? (after.startsWith('\n\n') ? '' : after.startsWith('\n') ? '\n' : '\n\n') : '';
      body.setRangeText(prefix + markdown + suffix, start, start, 'end');
      imageInsertPosition = body.selectionStart;
      renderAttachments();
      body.focus();
      body.dispatchEvent(new Event('input', {bubbles: true}));
    }
    imageAttachmentFeedback.textContent = errors.length
      ? errors.join(' ')
      : added.length ? added.length + '개 이미지를 본문에 넣었습니다.' : '';
    imageAttachmentFeedback.className = 'image-attachment-feedback' + (errors.length ? ' error' : '');
    imageAttachmentFeedback.hidden = !imageAttachmentFeedback.textContent;
  };

  addImagesButton.addEventListener('click', () => {
    imageInsertPosition = body.selectionStart;
    imageInput.click();
  });
  imageInput.addEventListener('change', async () => {
    const files = [...imageInput.files];
    imageInput.value = '';
    await addImageFiles(files);
  });

  body.addEventListener('input', () => {
    const parsed = readFrontMatter(body.value);
    if (parsed) {
      importFrontMatter(parsed);
    } else if (!titleInput.value.trim()) {
      const found = autoTitle(body.value);
      if (found) titleInput.value = found;
    }
    scheduleUpdate();
  });

  [titleInput, dateInput, tagsInput, customParentNameInput, customCategoryInput].forEach(input => input.addEventListener('input', scheduleUpdate));
  customParentSelect.addEventListener('change', () => { syncCustomParentFields(); scheduleUpdate(); });
  categorySelect.addEventListener('change', () => {
    customFields.hidden = categorySelect.value !== 'new';
    if (categorySelect.value === 'new') syncCustomParentFields();
    scheduleUpdate();
  });
  document.getElementById('add-category').addEventListener('click', () => {
    const currentCategory = selectedCategory();
    const hasCategoryContext = categorySelect.value !== 'auto' || titleInput.value.trim() || tagsInput.value.trim() || body.value.trim();
    const existingParent = hasCategoryContext && [...customParentSelect.options].find(option => option.value === currentCategory.parentKey);
    if (existingParent) customParentSelect.value = existingParent.value;
    categorySelect.value = 'new';
    customFields.hidden = false;
    syncCustomParentFields();
    (customParentSelect.value === 'new-parent' ? customParentNameInput : customCategoryInput).focus();
    scheduleUpdate();
  });

  document.getElementById('reset-post').addEventListener('click', () => {
    if ((body.value.trim() || titleInput.value.trim() || attachedImages.length) && !window.confirm('현재 초안을 지우고 새 글을 시작할까요?')) return;
    window.clearTimeout(updateTimer);
    window.clearTimeout(update.saveTimer);
    attachedImages.forEach(image => {
      if (image.previewUrl) URL.revokeObjectURL(image.previewUrl);
      void deleteImageBlob(image.id);
    });
    attachedImages = [];
    draftId = createId();
    renderAttachments();
    body.value = '';
    titleInput.value = '';
    dateInput.value = today();
    tagsInput.value = '';
    categorySelect.value = 'auto';
    customParentSelect.value = 'new-parent';
    customParentNameInput.value = '';
    customCategoryInput.value = '';
    customFields.hidden = true;
    const removed = safeClearDraft();
    update(false);
    status.textContent = removed ? '새 글을 시작합니다.' : '초안은 지웠지만 브라우저 저장 공간을 정리하지 못했습니다.';
    status.className = 'status' + (removed ? '' : ' error');
  });

  document.getElementById('download-post').addEventListener('click', async () => {
    window.clearTimeout(updateTimer);
    window.clearTimeout(update.saveTimer);
    if (attachmentsRestoring) {
      status.textContent = '이전에 첨부한 이미지를 불러오는 중입니다. 잠시 후 다시 저장해 주세요.';
      status.className = 'status';
      return;
    }
    const title = titleInput.value.trim() || autoTitle(body.value);
    const date = normalizeDate(dateInput.value);
    const tags = normalizeTags(tagsInput.value);
    const category = selectedCategory();
    if (!title) { status.textContent = '제목을 입력해 주세요.'; status.className = 'status error'; titleInput.focus(); return; }
    if (!date) { status.textContent = '올바른 날짜를 선택해 주세요.'; status.className = 'status error'; dateInput.focus(); return; }
    if (!body.value.trim()) { status.textContent = '본문을 입력해 주세요.'; status.className = 'status error'; body.focus(); return; }
    if (category.error) { status.textContent = category.error; status.className = 'status error'; (category.errorField === 'parent' ? (customParentSelect.value === 'new-parent' ? customParentNameInput : customParentSelect) : category.errorField === 'category' ? categorySelect : customCategoryInput).focus(); return; }

    const content = normalizeArticle(stripFrontMatter(body.value), title);
    const fields = [
      '---',
      'layout: post',
      'title: ' + yamlQuote(title),
      'date: ' + date + ' 00:00:00 +0900',
      'categories: [' + yamlQuote(category.parentLabel || category.parent) + ']',
      'section: ' + yamlQuote(category.section)
    ];
    if (category.isCustom) fields.push('section_parent: ' + yamlQuote(category.parentKey), 'section_parent_label: ' + yamlQuote(category.parentLabel), 'section_label: ' + yamlQuote(category.label));
    fields.push('tags: [' + (tags.length ? tags.map(yamlQuote).join(', ') : yamlQuote('Study')) + ']', '---', '');
    const fileContent = fields.join('\n') + content;
    const draftSaved = safeWriteDraft();
    const filenameSlug = title.normalize('NFKC').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]+/gu, '-').replace(/^-|-$/g, '').slice(0, 90) || 'post';
    const download = (blob, filename) => {
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      link.click();
      window.setTimeout(() => URL.revokeObjectURL(url), 1000);
    };
    const imagesToPackage = attachedImages.filter(image => body.value.includes('](' + image.path + ')'));
    try {
      if (imagesToPackage.length) {
        if (!window.JSZip) throw new Error('이미지 묶음 기능을 불러오지 못했습니다. 페이지를 새로고침한 뒤 다시 저장해 주세요.');
        const unavailable = imagesToPackage.find(image => !image.blob);
        if (unavailable) throw new Error(unavailable.name + ' 이미지를 복구하지 못했습니다. 다시 첨부해 주세요.');
        const archive = new window.JSZip();
        archive.file('_posts/' + date + '-' + filenameSlug + '.md', fileContent);
        imagesToPackage.forEach(image => archive.file(image.path.replace(/^\//, ''), image.blob));
        const zipBlob = await archive.generateAsync({type: 'blob'});
        download(zipBlob, date + '-' + filenameSlug + '.zip');
        status.textContent = draftSaved
          ? '게시글과 이미지가 담긴 ZIP을 저장했습니다. 저장소 루트에 압축을 풀어 주세요.'
          : 'ZIP 파일은 저장했지만 브라우저 초안은 저장하지 못했습니다.';
        status.className = 'status' + (draftSaved ? ' ok' : ' error');
      } else {
        download(new Blob([fileContent], {type: 'text/markdown;charset=utf-8'}), date + '-' + filenameSlug + '.md');
        status.textContent = draftSaved
          ? 'Markdown 파일을 저장하고 초안도 브라우저에 보관했습니다.'
          : 'Markdown 파일은 저장했지만 브라우저 초안은 저장하지 못했습니다.';
        status.className = 'status' + (draftSaved ? ' ok' : ' error');
      }
    } catch (error) {
      status.textContent = error.message || '파일을 저장하지 못했습니다.';
      status.className = 'status error';
    }
  });

  let importedDraft = false;
  let pendingAttachments = [];
  const storedDraft = safeReadDraft();
  if (storedDraft) {
    try {
      const saved = JSON.parse(storedDraft);
      if (saved && (saved.version === 2 || saved.version === 3 || saved.version === 4)) {
        draftId = typeof saved.draftId === 'string' && /^[a-zA-Z0-9-]{1,100}$/.test(saved.draftId) ? saved.draftId : draftId;
        titleInput.value = saved.title || '';
        dateInput.value = normalizeDate(saved.date) || today();
        tagsInput.value = saved.tags || '';
        const savedCategory = saved.category || 'auto';
        categorySelect.value = savedCategory;
        customCategoryInput.value = saved.customCategory || '';
        const savedParent = saved.version >= 3 ? saved.customParent || 'new-parent' : (categorySelect.value === 'new' ? 'custom' : 'new-parent');
        ensureCustomParentOption(savedParent, saved.customParentLabel || saved.customParentName);
        customParentSelect.value = savedParent;
        customParentNameInput.value = saved.customParentName || '';
        if (saved.categoryData && savedCategory.startsWith('section:')) {
          setCategoryFromFrontMatter(saved.categoryData.section, saved.categoryData.label, saved.categoryData.parent, saved.categoryData.parentLabel);
        } else if (!categorySelect.value) {
          categorySelect.value = 'auto';
        }
        customFields.hidden = categorySelect.value !== 'new';
        syncCustomParentFields();
        body.value = saved.body || '';
        if (Array.isArray(saved.attachments)) {
          attachedImages = saved.attachments.filter(image => image && typeof image.id === 'string' && typeof image.name === 'string' && isSafeImageFilename(image.filename) && image.path === '/assets/images/posts/' + draftId + '/' + image.filename)
            .map(image => ({...image, blob: null, previewUrl: null}));
          pendingAttachments = attachedImages;
        }
        importedDraft = true;
      } else {
        body.value = storedDraft;
        const parsed = readFrontMatter(body.value);
        if (parsed) importFrontMatter(parsed);
        else if (!titleInput.value) titleInput.value = autoTitle(body.value);
        importedDraft = true;
      }
    } catch (_) {
      body.value = storedDraft;
      const parsed = readFrontMatter(body.value);
      if (parsed) importFrontMatter(parsed);
      importedDraft = true;
    }
  } else {
    dateInput.value = today();
  }
  renderAttachments();
  update(false);
  if (importedDraft) status.textContent = '이전에 작성하던 초안을 불러왔습니다.';
  if (pendingAttachments.length) {
    attachmentsRestoring = true;
    status.textContent = '이전에 첨부한 이미지를 불러오는 중입니다.';
    Promise.all(pendingAttachments.map(async image => {
      try {
        image.blob = await readImageBlob(image.id);
        if (image.blob) image.previewUrl = URL.createObjectURL(image.blob);
        else image.missing = true;
      } catch (_) {
        image.missing = true;
      }
    })).then(() => {
      attachmentsRestoring = false;
      renderAttachments();
      update(false);
      if (pendingAttachments.some(image => image.missing)) {
        status.textContent = '일부 이미지를 브라우저 저장소에서 찾지 못했습니다. 다시 첨부해 주세요.';
        status.className = 'status error';
      } else {
        status.textContent = '작성 중인 초안과 이미지 ' + pendingAttachments.length + '장을 불러왔습니다.';
        status.className = 'status ok';
      }
    });
  }
  window.addEventListener('pagehide', () => {
    window.clearTimeout(updateTimer);
    if (body.value.trim() || titleInput.value.trim()) safeWriteDraft();
  });
})();
</script>

